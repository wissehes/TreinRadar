//
//  StationsManager.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation
import CoreLocation

extension MeasurementFormatter {
    static var myFormatter: MeasurementFormatter {
        let formatter = self.init()
        formatter.unitOptions = [.providedUnit, .naturalScale]
        formatter.unitStyle = .long
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }
}

final class StationsManager: ObservableObject {
    
    static let shared = StationsManager()

    @Published var stations: [FullStation]?
    @Published var nearbyStations: [StationWithDistance]?
    
    func getData() async {
        do {
            let data = try await API.shared.getStations()
            DispatchQueue.main.async { self.stations = data }
            if let location = LocationManager.shared.location {
                self.getNearbyStations(location: location)
            }
        } catch { print(error) }
    }
    
    func getStation(code: String) -> FullStation? {
        self.stations?.first { $0.code.lowercased() == code.lowercased() }
    }
    
    func getNearbyStations(location: CLLocation) {
        guard let stations = self.stations else { return }
//        guard let location = LocationManager.shared.location else { return }
        
        let mapped: [StationWithDistance] = stations.map { station in
            let stationLocation = CLLocation(latitude: station.lat, longitude: station.lng)
            let distance = location.distance(from: stationLocation)
            
            return .init(station, location: stationLocation, distance: distance)
        }
        
        let sorted = mapped.sorted { $0.distance < $1.distance }
        
        DispatchQueue.main.async {
            self.nearbyStations = Array(sorted.prefix(5))
        }
    }
}
