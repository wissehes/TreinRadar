//
//  StationsSearchView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import Defaults

struct SomeStation: Station {
    var code: String
    var sporen: [Spoor]
    var name: String
    var source: Source
    
    enum Source: String, Hashable {
        case favourites
        case nearby
        case allStations
    }
    
    init(code: String, sporen: [Spoor], name: String, source: Source) {
        self.code = code
        self.sporen = sporen
        self.name = name
        self.source = source
    }
    
    init(_ station: some Station, source: Source) {
        self.code = station.code
        self.sporen = station.sporen
        self.name = station.name
        self.source = source
    }
}

struct StationsSearchView: View {
    
    @EnvironmentObject var stationsManager: StationsManager
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var stations: [FullStation]?
    @State private var searchQuery = "";
    
    @State private var selectedStation: SomeStation?
    
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
    
    var stationsSearch: some View {
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
            stationsSearch
        } detail: {
            if let station = selectedStation {
                StationView(station: station)
            } else {
                Text("Kies een station.")
                    .navigationDestination(for: FullStation.self) { station in
                        StationView(station: station)
                    }
                    .navigationDestination(for: SavedStation.self) { station in
                        StationView(station: station)
                    }
                    .navigationDestination(for: StationWithDistance.self) { station in
                        StationView(station: station)
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
        }.tag(SomeStation(station, source: .allStations))
    }
}

struct StationsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StationsSearchView()
            .environmentObject(StationsManager.shared)
    }
}

#Preview {
    StationsSearchView()
}
