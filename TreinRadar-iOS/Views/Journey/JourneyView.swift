//
//  JourneyView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import SwiftUI
import Defaults

struct JourneyView: View {
    
    var journeyId: String
    
    @StateObject var vm = JourneyViewModel()
    @Default(.savedJourneys) var savedJourneys
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    /// Whether this journey is already saved
    var isSaved: Bool { savedJourneys.contains(where: { $0.code == journeyId }) }
    
    var body: some View {
        ZStack {
            if let journey = vm.journey {
                listView(journey)
            } else {
                LoadingView()
            }
        }
        .task {
            await vm.getData(journeyId)
            await vm.getLiveData(journeyId)
        }
        .onReceive(timer) { _ in
            Task { await vm.getLiveData(journeyId) }
        }
        .onDisappear {
            // Clean up timer
            timer.upstream.connect().cancel()
        }
        .navigationDestination(for: StopsAndGeometry.self) { item in
            if #available(iOS 17.0, *) {
                JourneyMapView(data: item, liveTrain: vm.live)
                    .navigationTitle("Kaart")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                LegacyJourneyMapView(geometry: item, inline: false)
                    .navigationTitle("Kaart")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationDestination(for: StopInfo.self) { stop in
            DeparturesView(uicCode: stop.uicCode)
        }
    }
    
    func listView(_ journey: JourneyPayload) -> some View {
        List {
            Section {
                Text("\(journey.category) richting **\(journey.destination?.name ?? "?")**")
                if journey.currentOrNextStop?.actualStock?.trainParts != nil {
                    trainParts
                }
                
                if let length = journey.currentOrNextStop?.actualStock?.numberOfParts {
                    Text("Lengte: \(length) delen")
                }
                if let seats = journey.currentOrNextStop?.actualStock?.numberOfSeats {
                    Text("Zitplaatsen: \(seats)")
                }
                if journey.stockNumbers != "0" {
                    Text("Materieel: \(journey.stockNumbers)")
                }
                
                if let currentStop = journey.currentStop {
                    Text("Huidig station: **\(currentStop.stop.name)**")
                } else if let nextStop = journey.nextStop {
                    Text("Volgend station: **\(nextStop.stop.name)**")
                }
            }
            
            if let live = vm.live {
                Section {
                    Text("Snelheid: \(live.speedAsMeasurement, formatter: MeasurementFormatter.kmhFormatter)")
                    HStack(alignment: .center) {
                        Text("Richting:")
                        Spacer()
                        
                        Text(verbatim: "⬆️")
                            .rotationEffect(Angle(degrees: live.direction), anchor: .center)
                    }
                } header: {
                    HStack {
                        Text("Info")
                        
                        Spacer()
                        
                        Button { Task { await vm.getLiveData(journeyId) } } label: {
                            Label("Ververs", systemImage: "arrow.clockwise.circle").labelStyle(.iconOnly)
                        }.disabled(vm.liveIsLoading)
                    }
                }
            }
            
            if !journey.notes.isEmpty {
                notes(journey.notes)
            }
            
            if let stops = vm.geojson {
                map(stops)
            }
            
            stops
        }.navigationTitle(journey.category)
            .refreshable {
                await vm.getData(journeyId)
                try? await Task.sleep(for: .seconds(1))
            }
            .toolbar {
                Button {
                    vm.toggleSave()
                } label: {
                    Label(isSaved ? "Verwijder uit opgeslagen reizen" : "Sla op", systemImage: "star")
                        .symbolVariant(isSaved ? .fill : .none)
                        .labelStyle(.iconOnly)
                }
                
                Menu {
                    Toggle("Laat alle stops zien", isOn: $vm.showAllStops)
                } label: {
                    Label("Meer...", systemImage: "ellipsis.circle")
                }
            }
    }
    
    func notes(_ notes: [JourneyNote]) -> some View {
            Section("Waarschuwingen") {
                ForEach(notes, id: \.text) { note in
                    VStack(alignment: .leading) {
                        Text(note.noteType.localized)
                        Text(note.text)
                    }
                }
            }
    }
    
    func map(_ stopsAndGeometry: StopsAndGeometry) -> some View {
        Section("Kaart") {
            LegacyJourneyMapView(geometry: stopsAndGeometry, inline: true)
                .frame(height: 400)
                .listRowInsets(EdgeInsets())
                .overlay {
                    NavigationLink(value: stopsAndGeometry) {
                        EmptyView()
                    }.opacity(0)
                }
        }
    }
    
    var stops: some View {
        Section("Stops") {
            
            if !vm.showingPreviousStops &&
                vm.currentStops != nil &&
                (vm.stops ?? []).count > (vm.currentStops ?? []).count {
                Button("Laat vorige stations zien") {
                    withAnimation {
                        vm.showingPreviousStops = true
                    }
                }
            }
            
            ForEach(vm.showingStops ?? [], id: \.id) { stop in
            stopItem(stop)
                    .contextMenu {
                            Text("Drukte: \(stop.crowdForecast?.rawValue ?? "?")")
                        
                        NavigationLink(value: stop.stop) {
                            Label("Vertrektijden", systemImage: "clock")
                        }
                    } preview: {
                        VStack(alignment:.leading) {
                            Text(stop.stop.name)
                                .font(.title)
                            Text("Aankomst: \(stop.arrivalTime ?? "")")
                            Text("Vertrek: \(stop.departureTime ?? "")")
                            Text("Spoor: \(stop.track ?? "")")
                        }
                            .frame(width: 400, height: 400)
                            .padding()
                    }

            }
        }
    }
    
    var trainParts: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 2.5) {
                    ForEach(vm.journey?.currentOrNextStop?.actualStock?.trainParts ?? [], id: \.stockIdentifier) { part in
                        AsyncImage(url: URL(string: part.image?.uri ?? "")) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }.frame(height: 60)
                    }
                }
            }
        }
    }
    
    func stopItem(_ stop: Stop) -> some View {
        HStack(alignment: .center, spacing: 10) {
            depOrArrTimes(stop)
            
            Spacer()
            
            Text(stop.stop.name)
                .italic(stop.shouldDisplayAsSkipped)
                .foregroundStyle(stop.shouldDisplayAsSkipped ? .secondary : .primary)
                .multilineTextAlignment(.trailing)
            
            if let crowdForecast = stop.crowdForecast {
                RushIcon(crowd: crowdForecast)
            }
            
            if let track = stop.track {
                PlatformIcon(platform: track)
            } else {
                EmptyView()
                    .frame(width: 35)
            }
        }
    }
    
    func depOrArrTimes(_ item: Stop) -> some View {
        VStack(alignment: .leading) {
            if let arrivalTime = item.arrivalTime {
                HStack(alignment: .center, spacing: 2.5) {
                    Text("A: \(arrivalTime)")
                    if item.arrivalDelay != 0 {
                        Text(verbatim: "+\(item.arrivalDelay)")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            
            if let departureTime = item.departureTime {
                HStack(alignment: .center, spacing: 2.5) {
                    Text("V: \(departureTime)")
                    if item.departureDelay != 0 {
                        Text(verbatim: "+\(item.departureDelay)")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
        }.frame(minWidth: 60, alignment: .center).font(.subheadline)
    }
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            JourneyView(journeyId: "6948")
        }
        
        StationsSearchView()
            .environmentObject(StationsManager.shared)
    }
}
