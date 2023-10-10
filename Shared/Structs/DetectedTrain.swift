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
    let train: LiveTrain
    let journey: JourneyPayload
    
    /// Distance in meters
    let distance: Double
    let location: CLLocation
    
    var formattedDistance: String {
        let distanceInMeters = Measurement(value: self.distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter.myFormatter
        
        return formatter.string(from: distanceInMeters)
    }
    
    init(train: LiveTrain, journey: JourneyPayload, distance: Double, location: CLLocation) {
        self.train = train
        self.journey = journey
        self.distance = distance
        self.location = location
    }
    
    init(train: TrainWithDistance, journey: JourneyPayload) {
        self.train = train.0
        self.journey = journey
        self.location = train.0.location
        self.distance = train.1
    }
}
