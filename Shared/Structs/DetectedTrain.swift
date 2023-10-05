//
//  DetectedTrain.swift
//  TreinRadar
//
//  Created by Wisse Hes on 05/10/2023.
//

import Foundation
import CoreLocation

/**
 Detected train
 */
struct DetectedTrain {
    let train: Train
    let journey: JourneyPayload
    
    /// Distance in meters
    let distance: Double
    let location: CLLocation
    
    var formattedDistance: String {
        let distanceInMeters = Measurement(value: self.distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter.myFormatter
        
        return formatter.string(from: distanceInMeters)
    }
    
    init(train: Train, journey: JourneyPayload, distance: Double, location: CLLocation) {
        self.train = train
        self.journey = journey
        self.distance = distance
        self.location = location
    }
    
    init(train: TrainWithDistance, journey: JourneyPayload) {
        self.train = train.train
        self.journey = journey
        self.location = train.location
        self.distance = train.distance
    }
}
