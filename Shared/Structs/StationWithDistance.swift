//
//  StationWithDistance.swift
//  TreinRadar
//
//  Created by Wisse Hes on 05/07/2023.
//

import Foundation
import CoreLocation

struct StationWithDistance: Station {
    var fullStation: FullStation

    var code: String { fullStation.code }
    var name: String { fullStation.name }
    var sporen: [Spoor] { fullStation.sporen }

    var location: CLLocation
    var distance: Double
    
    func fDistance() -> String {
        let distanceInMeters = Measurement(value: self.distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter.myFormatter
        
        return formatter.string(from: distanceInMeters)
    }
    
    init(_ station: FullStation, location: CLLocation, distance: Double) {
        self.location = location
        self.distance = distance
        self.fullStation = station
    }
}
