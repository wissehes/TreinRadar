//
//  StationsManager.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation
import CoreLocation

final class StationsManager: ObservableObject {
    
    static let shared = StationsManager()

    @Published var stations: [FullStation]?
    @Published var nearbyStations: [StationWithDistance]?
    
    func getData() async {
        do {
            let data = try await API.shared.getStations()
            DispatchQueue.main.async { self.stations = data }
//            if let location = LocationManager.shared.location {
//                await self.getNearbyStations(location: location)
//            }
        } catch { print(error) }
    }
    
    func getStation(code: String) -> FullStation? {
        self.stations?.first { $0.code.lowercased() == code.lowercased() }
    }
    
    private func getStations() async -> [FullStation]? {
        if let stations = self.stations, !stations.isEmpty {
            return stations
        }
        await self.getData()
        return self.stations
    }
    
    func getNearbyStations(location: CLLocation) async {
        guard let stations = await self.getStations() else { return }
//        guard let location = LocationManager.shared.location else { return }
        
        let mapped: [StationWithDistance] = stations.map { station in
            let stationLocation = CLLocation(latitude: station.lat, longitude: station.lng)
            let distance = location.distance(from: stationLocation)
            
            return .init(station, location: stationLocation, distance: distance)
        }
        
        let sorted = mapped.sorted { $0.distance < $1.distance }
        
//        Task { @MainActor in
//            self.nearbyStations = Array(sorted.prefix(5))
//        }
        
        DispatchQueue.main.async {
            self.nearbyStations = Array(sorted.prefix(5))
        }
    }
}
