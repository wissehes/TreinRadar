//
//  CurrentVehicles.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import Foundation

struct CurrentVehicles: Codable {
    let payload: CurrentVehiclesPayload
}

struct CurrentVehiclesPayload: Codable {
    let treinen: [Train]
}

/**
    Train without extra `info`.
 */
struct Train: Codable {
    let treinNummer: Int
    let ritID: String
    let lat, lng, snelheid, richting: Double
    let horizontaleNauwkeurigheid: Double
    let type: TrainType
    let bron: String
    let materieel: [Int]?

    enum CodingKeys: String, CodingKey {
        case treinNummer
        case ritID = "ritId"
        case lat, lng, snelheid, richting, horizontaleNauwkeurigheid, type, bron, materieel
    }
}

/**
 The type of a train.
 */
enum TrainType: String, Codable {
    case arr = "ARR"
    case ic = "IC"
    case spr = "SPR"
}
