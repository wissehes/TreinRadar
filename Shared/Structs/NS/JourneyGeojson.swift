//
//  JourneyGeojson.swift
//  TreinRadar
//
//  Created by Wisse Hes on 23/06/2023.
//

import Foundation
import MapKit

// MARK: - JourneyGeojsonResponse
struct JourneyGeojsonResponse: Codable {
    let payload: GeojsonPayload
}

// MARK: - GeojsonPayload
struct GeojsonPayload: Codable {
    let type: String
    let features: [JourneyFeature]
}

// MARK: - JourneyFeature
struct JourneyFeature: Codable {
    let type: String
    let properties: GeojsonProperties
    let geometry: GeojsonGeometry
}

// MARK: - GeojsonGeometry
struct GeojsonGeometry: Codable, Hashable, Identifiable {
    let type: String
    let coordinates: [[Double]]
    
    var id = UUID()
    
    var actualCoordinates: [CLLocationCoordinate2D] {
        return self.coordinates.filter({ $0.first != nil && $0.last != nil }).map {
            CLLocationCoordinate2D(latitude: $0.last!, longitude: $0.first!)
        }
    }
}

// MARK: - GeojsonProperties
struct GeojsonProperties: Codable {
    let stations: [String]?
}
