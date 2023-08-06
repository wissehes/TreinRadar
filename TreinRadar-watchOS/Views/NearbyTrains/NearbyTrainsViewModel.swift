//
//  NearbyTrainsViewModel.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 06/08/2023.
//

import Foundation
import AsyncLocationKit
import CoreLocation

final class NearbyTrainsViewModel: ObservableObject {
    let locationManager = AsyncLocationManager(desiredAccuracy: .nearestTenMetersAccuracy)
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var trains: [NearbyTrain]?
    
    @Published var error: String?
    
    func getLocation() async throws -> CLLocation? {
        if let location = self.location, location.timestamp < Date(timeIntervalSinceNow: 10) {
            return location
        }
        
        let authorization = await locationManager.requestPermission(with: .whenInUsage)
        DispatchQueue.main.async { self.authorizationStatus = authorization }
        
        if authorization != .authorizedWhenInUse {
            self.error = "Location not authorized"
            return nil;
        }
        
        let location = try await locationManager.requestLocation()
        
        guard case .didUpdateLocations(let locations) = location else { return nil }
        guard let myLocation = locations.first else {
            self.error = "No location returned"
            return nil;
        }
        
        DispatchQueue.main.async { self.location = myLocation }
        
        return myLocation
    }
    
    func getNearbyTrains() async {
        do {
            guard let location = try await self.getLocation() else { return }
            let trains = try await API.shared.getNearbyTrains(location: location)
            
            DispatchQueue.main.async { self.trains = trains }
        } catch { print(error) }
    }
}
