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
            
            Section {
                TimeTableSwitcher(viewType: $vm.viewType)
            }
            
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
//        .toolbar { toolbar }
        .task(id: vm.viewType) { await vm.loadData() }
        .refreshable { await vm.loadData() }
        .overlay {
            if vm.isLoading {
                LoadingView()
            }
        }
    }
    
//    @ToolbarContentBuilder
//    var toolbar: some ToolbarContent {
//        
//    }
    
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
    
    typealias TimeTableType = TimeTableViewModel.TimeTableType
}

extension TimeTableView {
    /// Timetable switcher button
    struct TimeTableSwitcher: View {
        @Binding var viewType: TimeTableType
        
        var body: some View {
            if #available(iOS 17.0, *) {
                Button(viewType.localized, systemImage: "arrow.up.arrow.down") {
                    if viewType == .arrivals {
                        viewType = .departures
                    } else {
                        viewType = .arrivals
                    }
                }.symbolEffect(.bounce, value: viewType)
            } else {
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
