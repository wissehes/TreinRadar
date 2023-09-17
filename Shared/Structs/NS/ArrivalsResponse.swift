//
//  ArrivalsResponse.swift
//  TreinRadar
//
//  Created by Wisse Hes on 17/09/2023.
//

import Foundation

// MARK: ArrivalsResponse
struct ArrivalsResponse: Codable {
    let payload: ArrivalsPayload
}

// MARK: ArrivalsPayload
struct ArrivalsPayload: Codable {
    let source: String
    let arrivals: [Arrival]
}

struct Arrival: Codable, Hashable {
    enum ArrivalStatus: String, Codable {
        case onStation = "ON_STATION"
        case incoming = "INCOMING"
        case departed = "DEPARTED"
        case unknown = "UNKNOWN"
    }
    
    let origin: String
    let name: String
    let plannedDateTime: Date
    let plannedTimeZoneOffset: Int?
    let actualDateTime: Date
    let actualTimeZoneOffset: Int?
    let plannedTrack: String?
    let actualTrack: String?
    let product: Product
    let trainCategory: String
    let cancelled: Bool
    let journeyDetailRef: String?
    let messages: [Message]
    let arrivalStatus: ArrivalStatus
}
