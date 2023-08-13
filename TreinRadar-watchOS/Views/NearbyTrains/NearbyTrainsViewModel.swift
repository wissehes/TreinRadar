//
//  NearbyTrainsViewModel.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 06/08/2023.
//

import Foundation
import AsyncLocationKit
import CoreLocation
import SwiftUI

enum LoadingState {
    case notDetermined
    case location
    case fetching
    case done
    
    var localizedText: String {
        switch self {
        case .notDetermined:
            return "Laden..."
        case .location:
            return "Locatie ophalen..."
        case .fetching:
            return "Treinen ophalen..."
        case .done:
            return "Klaar!"
        }
    }
}

final class NearbyTrainsViewModel: ObservableObject {
    let locationManager = AsyncLocationManager(desiredAccuracy: .nearestTenMetersAccuracy)
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var trains: [NearbyTrain]?
    
    @Published var loading: LoadingState = .notDetermined
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
        defer {
            self.updateLoading(state: .done)
        }
        
        do {
            self.updateLoading(state: .location)

            guard let location = try await self.getLocation() else { return }
            
            self.updateLoading(state: .fetching)
            
            let trains = try await API.shared.getNearbyTrains(location: location)
            
            DispatchQueue.main.async { withAnimation { self.trains = trains } }
        } catch {
            DispatchQueue.main.async { self.error = error.localizedDescription }
            print(error)
        }
    }
    
    private func updateLoading(state: LoadingState) {
        DispatchQueue.main.async {
            withAnimation {
                self.loading = state
            }
        }
    }
}
