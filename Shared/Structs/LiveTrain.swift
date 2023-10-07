//
//  LiveTrain.swift
//  TreinRadar
//
//  Created by Wisse Hes on 13/08/2023.
//

import Foundation
import CoreLocation

struct LiveTrain: Codable {
    let latitude: Double
    let longitude: Double
    
    /// Speed in km/h
    let speed: Double
    
    /// Direction as degrees from north
    let direction: Double
    
    /// Current or next station id
    let station: String?
    
    /// Current track
    let track: String?
    
    /// Train icon URL
    let image: String?
    
    /// Platform facilities for the current/next station
    let platformFacilities: [PlatformFacility]?
    
    /// Train images
    let images: [LiveTrainImage]?
    
    /// Current train location
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    /// Speed as `Measurement`
    var speedAsMeasurement: Measurement<UnitSpeed> {
        Measurement(value: self.speed, unit: UnitSpeed.kilometersPerHour)
    }
}

struct PlatformFacility: Codable {
    enum FacilityType: String, Codable  {
        case lift = "LIFT"
        case platformLetter = "PERRONLETTER"
        case escalator = "ROLTRAP"
        case stairs = "TRAP"
        case unknown = "unknown"
    }
    
    /// Amount of pixels before this facility
    let paddingLeft: Double
    /// The width of this item in pixels
    let width: Double
    /// Facility type
    let type: FacilityType
    /// Description of this facility, for example "A" for a platform letter
    let description: String
}

struct LiveTrainImage: Codable {
    let url: String
    /// Width in pixels
    let width: Double
    /// Height in pixels
    let height: Double
}
