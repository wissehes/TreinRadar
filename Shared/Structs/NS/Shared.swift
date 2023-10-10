//
//  Shared.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation

// MARK: Product
struct Product: Codable, Hashable {
    
    enum ModelType: String, Codable {
        case train = "TRAIN"
        case bus = "BUS"
        case tram = "TRAM"
        case metro = "METRO"
        case ferry = "FERRY"
        case walk = "WALK"
        case bike = "BIKE"
        case car = "CAR"
        case taxi = "TAXI"
        case subway = "SUBWAY"
        case sharedModality = "SHARED_MODALITY"
        case unknown = "UNKNOWN"
    }
    
    let number: String
    let categoryCode: String
    let shortCategoryName, longCategoryName: String
    let operatorCode, operatorName: String
    let type: ModelType
}

// MARK: - Message
struct Message: Codable, Hashable {
    let message: String
    let style: MessageStyle
}

enum MessageStyle: String, Codable, CaseIterable {
    case info = "INFO"
    case warning = "WARNING"
}


/**
 The type of a train.
 */
enum TrainType: String, Codable, Hashable {
    case arr = "ARR"
    case ic = "IC"
    case spr = "SPR"
}
