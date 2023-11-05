//
//  FavouriteStationsView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 21/09/2023.
//

import SwiftUI
import Defaults

struct FavouriteStationsView: View {
    
    @Default(.favouriteStations) var stations
    
    var body: some View {
        ForEach(stations, id: \.code, content: stationItem(station:))
    }
    
    func stationItem(station: SavedStation) -> some View {
        VStack(alignment: .leading) {
            Text(station.name)
        }.swipeActions {
            Button(role: .destructive) {
                removeStation(station)
            } label: {
                Label("Uit favorieten verwijderen", systemImage: "star.slash")
            }
        }.tag(SomeStation(station, source: .favourites))
    }
    
    func removeStation(_ station: some Station) {
        stations = stations.filter { $0.code != station.code }
    }
}

#Preview {
    FavouriteStationsView()
}
