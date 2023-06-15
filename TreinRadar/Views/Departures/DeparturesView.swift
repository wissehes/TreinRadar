//
//  DeparturesView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI

struct DeparturesView: View {
    
    var stationCode: String;
    var sporen: [Spoor]
    var naam: String
    
    @StateObject private var vm = DeparturesViewModel()
    
    init(stationCode: String, sporen: [Int], naam: String) {
        self.stationCode = stationCode
        self.sporen = sporen.map({ sp in Spoor(spoorNummer: sp.description) })
        self.naam = naam
    }
    
    init(station: some Station) {
        self.stationCode = station.code
        self.sporen = station.sporen
        self.naam = station.name
    }
    
    var filteredDepartures: [Departure]? {
        guard let departures = vm.departures else { return nil }
        
        switch vm.chosenSpoor {
        case .all:
            return departures
        case .specific(let spoor):
            return departures.filter { $0.actualTrack == spoor.spoorNummer }
        }
    }
    
    var body: some View {
        List(filteredDepartures ?? [], id: \.name) { item in
            NavigationLink(value: item.product.number) {
                depItem(departure: item)
            }
        }.navigationTitle(naam)
            .task { await vm.getData(stationCode) }
            .refreshable { await vm.getData(stationCode) }
            .navigationDestination(for: String.self, destination: { id in
                JourneyView(journeyId: id)
            })
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Picker(selection: $vm.chosenSpoor) {
                        Text("Alles")
                            .tag(ChosenSpoor.all)
                        
                        ForEach(self.sporen, id: \.spoorNummer) { spoor in
                            Text("Spoor \(spoor.spoorNummer)")
                                .tag(ChosenSpoor.specific(spoor))
                        }
                    } label: {
                        Label("Spoor", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
    }
    
    func depItem(departure item: Departure) -> some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text(item.product.longCategoryName)
                            .font(.callout)
                        Text(item.product.number)
                            .font(.caption)
                    }
                    Text(item.direction)
                        .bold()
                    Text(vm.formatDepartureDate(item))
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("Spoor")
                        .font(.subheadline)
                    Text(item.actualTrack ?? "?")
                        .bold()
                }
            }
            
            if(!item.messages.isEmpty) {
                messages(item.messages)
            }
        }
    }
    
    func messages(_ messages: [Message]) -> some View {
        ForEach(messages.filter({ $0.style != .info }), id: \.message) { msg in
            Text(msg.message)
                .font(.subheadline)
                .italic()
        }
    }
    
}

struct Departures_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeparturesView(stationCode: "UT", sporen: [1, 4], naam: "Vleuten")
        }
    }
}

//#Preview {
//    NavigationStack {
//        DeparturesView(stationCode: "VTN", sporen: [1, 4])
//    }
//}
