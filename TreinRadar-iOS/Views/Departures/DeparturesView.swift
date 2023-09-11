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
    
    init(uicCode: String) {
        let station = StationsManager.shared.getStation(code: .uicCode(uicCode))
        guard let station = station else { fatalError("Could not find station by uic code: \(uicCode)") }
        
        self.init(station: station)
    }
    
    var filteredDepartures: [Departure]? {
        guard var departures = vm.departures else { return nil }
        
        switch vm.chosenSpoor {
        case .all:
            break;
        case .specific(let spoor):
            departures = departures.filter { $0.actualTrack == spoor.spoorNummer }
        }
        
        if !vm.showCancelledTrains {
            departures = departures.filter { !$0.cancelled }
        }
        
        return departures
    }
    
    var body: some View {
        ZStack {
            if filteredDepartures != nil {
                listView
            } else {
                ProgressView()
            }
        }
        .navigationTitle(naam)
            .task { await vm.getData(stationCode) }
            .refreshable { await vm.getData(stationCode) }
            .navigationDestination(for: String.self, destination: { id in
                JourneyView(journeyId: id)
            })
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        spoorPicker
                        meldingenPicker
                        cancelledTrainsPicker
                    } label: {
                        Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
    }
    
    var listView: some View {
        List(filteredDepartures ?? [], id: \.name) { item in
            NavigationLink(value: item.product.number) {
                DepartureItemView(departure: item, chosenMessageStyle: vm.chosenMessageStyle)
            }
        }
    }
    
    var spoorPicker: some View {
        Picker(selection: $vm.chosenSpoor) {
            Text("Alles")
                .tag(ChosenSpoor.all)
            
            ForEach(self.sporen, id: \.spoorNummer) { spoor in
                Text("Spoor \(spoor.spoorNummer)")
                    .tag(ChosenSpoor.specific(spoor))
            }
        } label: {
            Label("Spoor", systemImage: "road.lanes")
        }.pickerStyle(.menu)
    }
    
    var meldingenPicker: some View {
        Picker(selection: $vm.chosenMessageStyle) {
            Text("Alles")
                .tag(ChosenMessageStyle.all)
            
            ForEach(MessageStyle.allCases, id: \.rawValue) { style in
                Text(style.readable)
                    .tag(ChosenMessageStyle.specific(style))
            }
        } label: {
            Label("Meldingen", systemImage: "exclamationmark.bubble")
        }.pickerStyle(.menu)
    }
    
    var cancelledTrainsPicker: some View {
        Toggle(isOn: $vm.showCancelledTrains) {
            Label("Laat geannuleerde treinen zien", systemImage: "exclamationmark.triangle")
        }
    }
}

struct Departures_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeparturesView(stationCode: "UT", sporen: [1, 4], naam: "Utrecht C")
        }
    }
}

//#Preview {
//    NavigationStack {
//        DeparturesView(stationCode: "VTN", sporen: [1, 4])
//    }
//}
