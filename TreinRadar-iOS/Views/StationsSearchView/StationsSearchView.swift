//
//  StationsSearchView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import Defaults

/// Selected Station
enum SelectedStation: Hashable {
    /// Favourite station
    case favourite(SavedStation)
    /// Full station
    case full(FullStation)
    /// Nearby station
    case nearby(FullStation)
}

struct StationsSearchView: View {
    
    @EnvironmentObject var stationsManager: StationsManager
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var searchQuery = ""
    @State private var selectedStation: SelectedStation?
    
    @Default(.favouriteStations) var favStations
    
    var filtered: [FullStation]? {
        guard let stations = stationsManager.stations else { return nil };
        
        if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return stations.filter { $0.land == .nl }
        } else {
            /// Filter the stations by search query
            var filtered = stations.filter {
                $0.land == .nl && $0.namen.lang.lowercased()
                    .contains(searchQuery.lowercased())
            }
            
            /// Reverse the array, so that it can be used by `Array.partition()`.
            filtered.reverse()
            
            /// Partition the array in 2. The first being all "centraal" stations
            /// and the second one being the 'normal' stations
            let pivot = filtered.partition(by: { !$0.namen.lang.hasSuffix("Centraal") })
            
            /// Filter the regular stations by name
            if pivot != filtered.endIndex {
                filtered[...pivot].sort(by: { $0.name.lowercased() < $1.name.lowercased() })
                filtered[pivot...].sort(by: { $0.name.lowercased() < $1.name.lowercased() })
            } else {
                filtered.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
            }
            
            return filtered
        }
    }
    
    func addFavStation(_ station: FullStation) {
        if (favStations.first(where: { $0.code == station.code }) == nil) {
            withAnimation {
                favStations.append(SavedStation(station))
            }
        }
    }
    
    // List sidebar on iPad / List main view on iPhone
    var sidebar: some View {
        List(selection: $selectedStation) {
            // Favourite stations
            if !favStations.isEmpty && searchQuery.isEmpty {
                Section("Favorieten") {
                    FavouriteStationsView()
                }
            }
            
            // Nearby stations
            if stationsManager.nearbyStations != nil, searchQuery.isEmpty {
                Section("In de buurt") {
                    NearbyStationsView()
                }
            }
            
            // All stations
            Section("Stations") {
                ForEach(filtered ?? [], id: \.code, content: stationItem(station:))
            }
            
        }
        .animation(.easeInOut, value: favStations)
        .navigationTitle("Stations")
        .task { await stationsManager.getData() }
        .searchable(text: $searchQuery)
        .overlay {
            if (filtered?.isEmpty ?? true) && !searchQuery.isEmpty, #available(iOS 17.0, *) {
                ContentUnavailableView("Geen zoekresultaten", systemImage: "magnifyingglass")
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            NavigationStack {
                if let station = selectedStation {
                    StationView(station: station)
                } else {
                    Text("Kies een station.")
                }
            }
        }
    }
    
    func stationItem(station: FullStation) -> some View {
        VStack(alignment: .leading) {
            Text(station.namen.lang)
        }.swipeActions {
            Button {
                addFavStation(station)
            } label: {
                Label("Aan favorieten toevoegen", systemImage: "star")
            }.tint(.yellow)
        }.tag(SelectedStation.full(station))
    }
}

#Preview {
    StationsSearchView()
        .environmentObject(StationsManager.shared)
        .environmentObject(LocationManager.shared)
}
