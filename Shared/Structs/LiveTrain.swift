//
//  LiveTrain.swift
//  TreinRadar
//
//  Created by Wisse Hes on 13/08/2023.
//

import Foundation

struct LiveTrain: Codable {
    let latitude: Double
    let longitude: Double
    
    /// Speed in km/h
    let speed: Double
    
    /// Direction as degrees from north
    let direction: Double
    
    /// Current track
    let track: String?
}
