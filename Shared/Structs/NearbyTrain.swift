//
//  NearbyTrain.swift
//  TreinRadar
//
//  Created by Wisse Hes on 06/08/2023.
//

import Foundation

struct NearbyTrain: Codable, Identifiable {
    var id: String { self.ritID }
    
    let treinNummer: Int
    let ritID: String
    let lat, lng, richting: Double
    let snelheid: Int
    let horizontaleNauwkeurigheid: Double
    let type: TrainType
    let bron: String
    let materieel: [Int]?
    
    /// Distance in kilometers
    let distance: Int
    
    // TODO: Implement `info` fields

    enum CodingKeys: String, CodingKey {
        case treinNummer
        case ritID = "ritId"
        case lat, lng, snelheid, richting, horizontaleNauwkeurigheid, type, bron, materieel, distance
    }
}
