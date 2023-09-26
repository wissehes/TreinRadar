//
//  StationsView.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 21/09/2023.
//

import SwiftUI
import Defaults

/**
 Shows the favourited stations
 */
struct StationsView: View {
    
    @Default(.favouriteStations) var stations
    @EnvironmentObject var watchManager: WatchConnectManager
    
    var body: some View {
        List(stations, id: \.code) { station in
            NavigationLink(station.name) {
                DeparturesView(station: station)
            }
        }.navigationTitle("Stations")
            .onAppear {
                watchManager.requestUpdateStations()
            }
    }
}

#Preview {
    NavigationStack {
        StationsView()
    }
}
