//
//  StationsSearchView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import Defaults

struct StationsSearchView: View {
    
    @EnvironmentObject var stationsManager: StationsManager
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var stations: [FullStation]?
    @State private var searchQuery = "";
    
    @State private var path = NavigationPath()
    
    @Default(.favouriteStations) var favStations
    
    var filtered: [FullStation]? {
        guard let stations = stationsManager.stations else { return nil };
        
        if searchQuery.isEmpty {
            return stations.filter { $0.land == .nl }
        } else {
            return stations.filter {
                $0.land == .nl && $0.namen.lang.lowercased()
                    .contains(searchQuery.lowercased())
            }
        }
    }
    
    func addFavStation(_ station: FullStation) {
        if (favStations.first(where: { $0.code == station.code }) == nil) {
            withAnimation {
                favStations.append(SavedStation(station))
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                
                if !favStations.isEmpty && searchQuery.isEmpty {
                    Section("Favorieten") {
                        FavouriteStationsView()
                    }
                }
                
                if stationsManager.nearbyStations != nil, searchQuery.isEmpty {
                    Section("In de buurt") {
                        NearbyStationsView()
                    }
                }
                
                Section("Stations") {
                    ForEach(filtered ?? [], id: \.code, content: stationItem(station:))
                }
                
            }.navigationTitle("Stations")
                .task { await stationsManager.getData() }
                .searchable(text: $searchQuery)
                .overlay {
                    if (filtered?.isEmpty ?? true) && !searchQuery.isEmpty, #available(iOS 17.0, *) {
                        ContentUnavailableView("Geen zoekresultaten", systemImage: "magnifyingglass")
                    }
                }
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
    
    func stationItem(station: FullStation) -> some View {
        NavigationLink(value: station) {
            VStack(alignment: .leading) {
                Text(station.namen.lang)
            }.swipeActions {
                Button {
                    addFavStation(station)
                } label: {
                    Label("Aan favorieten toevoegen", systemImage: "star")
                }.tint(.yellow)
            }
        }
    }
}

struct StationsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StationsSearchView()
            .environmentObject(StationsManager.shared)
    }
}

//#Preview {
//    StationsSearchView()
//}
