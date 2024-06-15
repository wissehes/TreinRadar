//
//  TimeTableView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 24/05/2024.
//

import SwiftUI

struct TimeTableView: View {
    
    // Necessary variables
    var stationCode: String;
    var sporen: [Spoor]
    var naam: String
    
    // State
    @StateObject private var vm: TimeTableViewModel
    
    // Initializers
    init(
        stationCode: String,
        sporen: [Int],
        naam: String,
        viewType: TimeTableViewModel.TimeTableType = .departures
    ) {
        self.stationCode = stationCode
        self.sporen = sporen.map({ sp in Spoor(spoorNummer: sp.description) })
        self.naam = naam
        self._vm = .init(wrappedValue: .init(stationCode: stationCode, viewType: viewType))
    }
    
    init(station: some Station, viewType: TimeTableType) {
        self.stationCode = station.code
        self.sporen = station.sporen
        self.naam = station.name
        
        self._vm = .init(wrappedValue: .init(stationCode: station.code, viewType: viewType))
    }
    
    init(uicCode: String, viewType: TimeTableType) {
        let station = StationsManager.shared.getStation(code: .uicCode(uicCode))
        guard let station = station else { fatalError("Could not find station by uic code: \(uicCode)") }
        
        self.init(station: station, viewType: viewType)
    }
    
    var body: some View {
        List {
            
            // Switcher
            Section {
                TimeTableSwitcher(viewType: $vm.viewType)
            }
            
            // Items
            Section(vm.viewType.localized) {
                switch vm.viewType {
                case .departures:
                    self.departures
                case .arrivals:
                    self.arrivals
                }
            }
        }
        .animation(.interactiveSpring, value: vm.viewType)
        .navigationTitle(naam)
        .navigationBarTitleDisplayMode(.large)
        .toolbar { toolbar }
        .task(id: vm.viewType) { await vm.loadData() }
        .refreshable {
            await vm.loadData()
            try? await Task.sleep(for: .seconds(0.5))
        }
        .overlay {
            if vm.isLoading {
                LoadingView()
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
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
    
    var departures: some View {
        ForEach(vm.departures ?? [], id: \.name) { item in
            NavigationLink(value: item) {
                DepartureItemView(item: item, chosenMessageStyle: vm.chosenMessageStyle)
            }
        }
    }
    
    var arrivals: some View {
        ForEach(vm.arrivals ?? [], id: \.name) { item in
            NavigationLink(value: item) {
                DepartureItemView(item: item, chosenMessageStyle: vm.chosenMessageStyle)
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
    
    typealias TimeTableType = TimeTableViewModel.TimeTableType
}

extension TimeTableView {
    /// Timetable switcher button
    struct TimeTableSwitcher: View {
        @Binding var viewType: TimeTableType
        
        var body: some View {
            if #available(iOS 17.0, *) {
                // Button with bounce effect
                Button(viewType.localized, systemImage: "arrow.up.arrow.down") {
                    if viewType == .arrivals {
                        viewType = .departures
                    } else {
                        viewType = .arrivals
                    }
                }.symbolEffect(.bounce, value: viewType)
            } else {
                // Without bounce effect for < ios 17
                Button(viewType.localized, systemImage: "arrow.up.arrow.down") {
                    if viewType == .arrivals {
                        viewType = .departures
                    } else {
                        viewType = .arrivals
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TimeTableView(
            stationCode: "VTN",
            sporen: [1, 4],
            naam: "Vleuten"
        )
    }
}
