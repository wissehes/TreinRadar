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
            .overlay {
                if stations.isEmpty {
                    contentUnavailableOverlay
                }
            }
            .onAppear {
                watchManager.requestUpdateStations()
            }
    }
    
    @ViewBuilder
    var contentUnavailableOverlay: some View {
        if #available(watchOS 10, *) {
            ContentUnavailableView(
                "Nog geen favoriete stations",
                systemImage: "tram.circle",
                description: Text("Voeg stations toe aan je favorieten via de app op je iPhone, daarna verschijnen ze hier."))
        } else {
            VStack(alignment: .center) {
                Text("Nog geen favoriete stations")
                    .font(.headline)
                Text("Voeg stations toe aan je favorieten via de app op je iPhone, daarna verschijnen ze hier.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StationsView()
    }.environmentObject(WatchConnectManager())
}
