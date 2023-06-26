//
//  StationsSearchViewModel.swift
//  TreinRadar
//
//  Created by Wisse Hes on 25/06/2023.
//

import Foundation
import CoreLocation

struct StationWithDistance: Station {
    var code: String
    var name: String
    var sporen: [Spoor]
    var location: CLLocation
    var distance: Double
    
    func fDistance() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let number = NSNumber(value: self.distance)
        
        return formatter.string(from: number) ?? self.distance.formatted()
    }
    
    init(_ station: FullStation, location: CLLocation, distance: Double) {
        self.code = station.code
        self.name = station.namen.lang
        self.sporen = station.sporen
        self.location = location
        self.distance = distance
    }
}

final class StationsSearchViewModel: ObservableObject {
    init() {
        LocationManager.shared.requestLocation()
    }
    
    var nearbyStations: [StationWithDistance]? {
        guard let stations = StationsManager.shared.stations else { return nil }
        guard let location = LocationManager.shared.location else { return nil }
        let me = CLLocation(latitude: location.latitude, longitude: location.longitude)

        let mapped: [StationWithDistance] = stations.map { station in
            let stationLocation = CLLocation(latitude: station.lat, longitude: station.lng)
            let distance = me.distance(from: stationLocation)
            
            return .init(station, location: stationLocation, distance: distance)
        }
        
        let sorted = mapped.sorted { $0.distance < $1.distance }
        
        return Array(sorted.prefix(5))
    }
}
