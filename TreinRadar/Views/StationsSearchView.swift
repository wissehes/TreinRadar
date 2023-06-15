//
//  StationsSearchView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import Defaults

struct StationsSearchView: View {
    
    @State private var stations: [FullStation]?
    @State private var searchQuery = "";
    @Default(.favouriteStations) var favStations
    
    var filtered: [FullStation]? {
        guard let stations = stations else { return nil };
        
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
    
    func removeFavStation(_ station: some Station) {
        favStations = favStations.filter { $0.code != station.code }
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                if !favStations.isEmpty {
                    Section("Favorieten") {
                        ForEach(favStations, id: \.code) { station in
                            NavigationLink(value: station) {
                                VStack(alignment: .leading) {
                                    Text(station.name)
                                }.swipeActions {
                                    Button(role: .destructive) {
                                        removeFavStation(station)
                                    } label: {
                                        Label("Uit favorieten verwijderen", systemImage: "star.slash")
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section("Stations") {
                    ForEach(filtered ?? [], id: \.code) {station in
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
            }.navigationTitle("Stations")
                .task {
                    do {
                        let data = try await API.shared.getStations()
                        DispatchQueue.main.async { self.stations = data }
                    } catch { print(error) }
                }
                .searchable(text: $searchQuery)
                .navigationDestination(for: FullStation.self) { station in
                    DeparturesView(station: station)
                }
                .navigationDestination(for: SavedStation.self) { station in
                    DeparturesView(station: station)
                }
        }
    }
}

struct StationsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StationsSearchView()
    }
}

//#Preview {
//    StationsSearchView()
//}
