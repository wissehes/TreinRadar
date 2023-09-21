//
//  NearbyStationsView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 21/09/2023.
//

import SwiftUI

struct NearbyStationsView: View {
        
    @EnvironmentObject var stationsManager: StationsManager
    
    var body: some View {
        ForEach(stationsManager.nearbyStations ?? [], id: \.code, content: stationItem(station:))
    }
    
    func stationItem(station: StationWithDistance) -> some View {
        NavigationLink(value: station) {
            VStack(alignment: .leading) {
                Text(station.name)
                Text(station.fDistance())
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    NearbyStationsView()
}
