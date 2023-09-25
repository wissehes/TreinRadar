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
    
    var body: some View {
        List(stations, id: \.code) { station in
            Text(station.name)
        }.navigationTitle("Stations")
    }
}

#Preview {
    NavigationStack {
        StationsView()
    }
}
