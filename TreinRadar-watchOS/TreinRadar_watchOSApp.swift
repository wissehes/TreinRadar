//
//  TreinRadar_watchOSApp.swift
//  TreinRadar-watchOS Watch App
//
//  Created by Wisse Hes on 06/08/2023.
//

import SwiftUI
import Defaults

@main
struct TreinRadar_watchOS_Watch_AppApp: App {
    @StateObject var watchManager = WatchConnectManager()
    @Default(.favouriteStations) var favouriteStations
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(watchManager)
                .onReceive(watchManager.subject) { stations in
                    // Update favouriteStations when the iOS app sends a new array
                    favouriteStations = stations
                }
        }
    }
}
