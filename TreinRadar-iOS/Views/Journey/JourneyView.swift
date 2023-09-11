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
    var isSaved: Bool { savedJourneys.first(where: { $0.code == journeyId }) != nil }
    
    var body: some View {
        ZStack {
            if let journey = vm.journey {
                listView(journey)
            } else {
                ProgressView()
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
            JourneyMapView(geometry: item, inline: false)
                .navigationTitle("Kaart")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationDestination(for: StopInfo.self) { stop in
            DeparturesView(uicCode: stop.uicCode)
        }
    }
    
    func listView(_ journey: JourneyPayload) -> some View {
        List {
            Section {
                Text("\(journey.category) richting **\(journey.destination?.name ?? "?")**")
                if journey.firstRealStop?.actualStock?.trainParts != nil {
                    trainParts
                }
                
                if let length = journey.firstRealStop?.actualStock?.numberOfParts {
                    Text("Lengte: \(length) delen")
                }
                if let seats = journey.firstRealStop?.actualStock?.numberOfSeats {
                    Text("Zitplaatsen: \(seats)")
                }
                if journey.stockNumbers != "0" {
                    Text("Materieel: \(journey.stockNumbers)")
                }
            }
            
            if let live = vm.live {
                Section("Info") {
                    Text("Snelheid: \(live.speed) km/h")
                    HStack(alignment: .center) {
                        Text("Richting:")
                        Spacer()
                        
                        Text("⬆️")
                            .rotationEffect(Angle(degrees: live.direction), anchor: .center)
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
                        Text(note.noteType)
                        Text(note.text)
                    }
                }
            }
    }
    
    func map(_ stopsAndGeometry: StopsAndGeometry) -> some View {
        Section("Kaart") {
            JourneyMapView(geometry: stopsAndGeometry, inline: true)
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
            
            if !vm.showingPreviousStops && vm.currentStops != nil  {
                Button("Laat vorige stations zien") {
                    withAnimation {
                        vm.showingPreviousStops = true
                    }
                }
            }
            
            ForEach(vm.showingStops ?? [], id: \.id) { stop in
            stopItem(stop)
                .contextMenu {
                    VStack {
                        Text("Drukte: \(stop.crowdForecast?.rawValue ?? "?")")
                    }
                    
                    NavigationLink(value: stop.stop) {
                        Label("Vertrektijden", systemImage: "clock")
                    }

                }
            }
        }
    }
    
    var trainParts: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 2.5) {
                    ForEach(vm.journey?.firstRealStop?.actualStock?.trainParts ?? [], id: \.stockIdentifier) { part in
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
                .italic(stop.status == .passing)
                .foregroundStyle(stop.status == .passing ? .secondary : .primary)
                .multilineTextAlignment(.trailing)
            
            if let track = stop.track {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor, lineWidth: 2.5)
                    .overlay(
                        Text(track)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    )
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding(2.5)
            } else {
                EmptyView()
                    .frame(width: 35)
            }
        }
    }
    
    func depOrArrTimes(_ item: Stop) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 2.5) {
                Text("A: \(item.arrivalTime ?? "--:--")")
                if item.arrivalDelay != 0 {
                    Text("+\(item.arrivalDelay)")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            HStack(alignment: .center, spacing: 2.5) {
                Text("V: \(item.departureTime ?? "--:--")")
                if item.departureDelay != 0 {
                    Text("+\(item.departureDelay)")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }.frame(minWidth: 70, alignment: .center).font(.subheadline)
    }
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            JourneyView(journeyId: "6948")
        }
        
        ContentView()
    }
}
