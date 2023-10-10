//
//  CurrentVehicles.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import Foundation
import CoreLocation

struct CurrentVehicles: Codable {
    let payload: CurrentVehiclesPayload
}

struct CurrentVehiclesPayload: Codable {
    let treinen: [Train]
}

/**
    Train without extra `info`.
 */
struct Train: Codable, Identifiable, Hashable {
    let treinNummer: Int
    let ritID: String
    let lat, lng, richting: Double
    let snelheid: Double
    let horizontaleNauwkeurigheid: Double
    let type: TrainType
    let bron: String
    let materieel: [Int]?
    
    var id: String { self.ritID }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }

    enum CodingKeys: String, CodingKey {
        case treinNummer
        case ritID = "ritId"
        case lat, lng, snelheid, richting, horizontaleNauwkeurigheid, type, bron, materieel
    }
}
