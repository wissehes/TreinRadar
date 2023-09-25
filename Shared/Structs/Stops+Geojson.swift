//
//  Stops+Geojson.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation
import MapKit

struct StopsAndGeometry: Hashable, Codable {
    static func == (lhs: StopsAndGeometry, rhs: StopsAndGeometry) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let stops: [StopInfo]
    let coordinates: [[Double]]
    
    var actualCoordinates: [CLLocationCoordinate2D] {
        return self.coordinates.map {
            CLLocationCoordinate2D(latitude: $0.last!, longitude: $0.first!)
        }
    }
}
