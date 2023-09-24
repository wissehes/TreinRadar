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
    
    /// Current track
    let track: String?
    
    /// Train image URL
    let image: String?
    
    /// Current train location
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
