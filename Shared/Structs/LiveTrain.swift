//
//  LiveTrain.swift
//  TreinRadar
//
//  Created by Wisse Hes on 13/08/2023.
//

import Foundation
import CoreLocation

struct LiveTrain: Codable, Hashable, Identifiable {
    var id: String { self.journeyId }
    
    static func == (lhs: LiveTrain, rhs: LiveTrain) -> Bool {
        lhs.id == rhs.id
    }
    
    let latitude: Double
    let longitude: Double
    
    /// Speed in km/h
    let speed: Double
    /// Direction as degrees from north
    let direction: Double
    
    /// Train type (IC, SPR, ARR)
    let type: TrainType
    /// Journey id
    let journeyId: String
    
    /// Current or next station id
    let station: String?
    /// Current track
    let track: String?
    /// Platform facilities for the current/next station
    let platformFacilities: [PlatformFacility]?
    /// Train images
    let images: [LiveTrainImage]?
    
    /// Train icon URL
    let image: String?
    
    /// Train location
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    /// Train coordinate
    var coordinate: CLLocationCoordinate2D {
        location.coordinate
    }
    
    /// Speed as `Measurement`
    var speedAsMeasurement: Measurement<UnitSpeed> {
        Measurement(value: self.speed, unit: UnitSpeed.kilometersPerHour)
    }
}

struct PlatformFacility: Codable, Hashable {
    enum FacilityType: String, Codable, Hashable  {
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

struct LiveTrainImage: Codable, Hashable {
    let url: String
    /// Width in pixels
    let width: Double
    /// Height in pixels
    let height: Double
}
