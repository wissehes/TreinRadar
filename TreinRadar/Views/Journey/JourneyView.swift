//
//  JourneyView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import SwiftUI

struct JourneyView: View {
    
    var journeyId: String
    
    @StateObject var vm = JourneyViewModel()
    
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
        }
        .navigationDestination(for: StopsAndGeometry.self) { item in
            JourneyMapView(geometry: item, inline: false)
                .navigationTitle("Kaart")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func listView(_ journey: JourneyPayload) -> some View {
        List {
            Section {
                Text("\(vm.category) richting **\(vm.destination?.name ?? "?")**")
                if vm.firstRealStop?.actualStock?.trainParts != nil {
                    trainParts
                }
                
                if let length = vm.firstRealStop?.actualStock?.numberOfParts {
                    Text("Lengte: \(length) delen")
                }
                if let seats = vm.firstRealStop?.actualStock?.numberOfSeats {
                    Text("Zitplaatsen: \(seats)")
                }
                if vm.stockNumbers != "0" {
                    Text("Materieel: \(vm.stockNumbers)")
                }
            }
            
            if !journey.notes.isEmpty {
                Section("Waarschuwingen") {
                    ForEach(journey.notes, id: \.text) { note in
                        VStack(alignment: .leading) {
                            Text(note.noteType)
                            Text(note.text)
                        }
                    }
                }
            }
            
            if let geojson = vm.geojson {
                Section("Kaart") {
                    JourneyMapView(geometry: geojson, inline: true)
                        .frame(height: 400)
                        .listRowInsets(EdgeInsets())
                        .overlay {
                            NavigationLink(value: geojson) {
                                EmptyView()
                            }.opacity(0)
                        }
                }
            }
            
            Section("Stops") {
                ForEach(vm.actualStops ?? [], id: \.id) { stop in
                    HStack(alignment: .center, spacing: 10) {
                        depOrArrTimes(stop)
                        
                        Text(stop.stop.name)
                            .italic(stop.status == .passing)
                            .foregroundStyle(stop.status == .passing ? .secondary : .primary)
                    }
                }
            }
        }.navigationTitle(vm.category)
            .toolbar {
                Menu {
                    Toggle("Laat alle stops zien", isOn: $vm.showAllStops)
                } label: {
                    Label("Meer...", systemImage: "ellipsis.circle")
                }
                
            }
    }
    
    var trainParts: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 2.5) {
                    ForEach(vm.firstRealStop?.actualStock?.trainParts ?? [], id: \.stockIdentifier) { part in
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
    
    func depOrArrTimes(_ item: Stop) -> some View {
        VStack(alignment: .leading) {
            Text("A: \(item.arrival?.plannedTime?.timeFormat() ?? "--:--")")
            Text("V: \(item.departure?.plannedTime?.timeFormat() ?? "--:--")")
        }.frame(width: 60, alignment: .center).font(.subheadline)
    }
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            JourneyView(journeyId: "3078")
        }
        
        ContentView()
    }
}
