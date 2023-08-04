//
//  LocationManager.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var permissionStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.startMonitoringSignificantLocationChanges()
        manager.delegate = self
    }
    
    func requestLocation() {
        print("Requesting location...")
        if permissionStatus == .notDetermined {
            print("Permission status was undetermined")
            manager.requestWhenInUseAuthorization()
        }
        
        if permissionStatus == .authorizedAlways || permissionStatus == .authorizedWhenInUse {
            print("Permission authorized")
            manager.requestLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.permissionStatus = manager.authorizationStatus
        self.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        print("Got location!")

        guard let location = locations.first else { return }
        Task {
            await StationsManager.shared.getNearbyStations(location: location)
            await TrainManager.shared.getCurrentJourney(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
