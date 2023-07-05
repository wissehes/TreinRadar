//
//  StationWithDistance.swift
//  TreinRadar
//
//  Created by Wisse Hes on 05/07/2023.
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
        let distanceInMeters = Measurement(value: self.distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter.myFormatter
        
        return formatter.string(from: distanceInMeters)
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 0
//        let number = NSNumber(value: self.distance)
//
//        return formatter.string(from: number) ?? self.distance.formatted()
    }
    
    init(_ station: FullStation, location: CLLocation, distance: Double) {
        self.code = station.code
        self.name = station.namen.lang
        self.sporen = station.sporen
        self.location = location
        self.distance = distance
    }
}
