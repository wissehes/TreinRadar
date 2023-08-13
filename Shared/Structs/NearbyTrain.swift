//
//  NearbyTrain.swift
//  TreinRadar
//
//  Created by Wisse Hes on 06/08/2023.
//

import Foundation

// MARK: - NearbyTrainElement
struct NearbyTrain: Codable, Identifiable {
    var id: String { self.journeyID }
    
    let journeyID: String
    let distance, speed, direction: Double
    let image: [String]
    let journey: NearbyTrainJourney

    enum CodingKeys: String, CodingKey {
        case journeyID = "journeyId"
        case distance, speed, direction, image, journey
    }
}

// MARK: - NearbyTrainJourney
struct NearbyTrainJourney: Codable {
    let destination, origin, category, journeyOperator: String?
    let notes: [String]

    enum CodingKeys: String, CodingKey {
        case destination, origin, category
        case journeyOperator = "operator"
        case notes
    }
}
