//
//  TreinRadarApp.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import Defaults

@main
struct TreinRadarApp: App {
    @StateObject var stationsManager = StationsManager.shared
    @StateObject var locationManager = LocationManager.shared
    @StateObject var trainManager = TrainManager.shared
    @StateObject var watchManager = WatchConnectManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stationsManager)
                .environmentObject(locationManager)
                .environmentObject(trainManager)
                .environmentObject(watchManager)
                .onAppear { locationManager.requestLocation() }
                .onReceive(watchManager.updateSubject, perform: { _ in
                    // Send update when update is requested
                    watchManager.updateStations(Defaults[.favouriteStations])
                })
                .task {
                    // Watch for changes of the favourite stations and send
                    // them to the watchOS app
                    for await value in Defaults.updates(.favouriteStations) {
                        watchManager.updateStations(value)
                    }
                }
        }
    }
}
