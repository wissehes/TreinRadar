//
//  TreinRadarApp.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI

@main
struct TreinRadarApp: App {
    @StateObject var stationsManager = StationsManager.shared
    @StateObject var locationManager = LocationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stationsManager)
                .environmentObject(locationManager)
        }
    }
}
