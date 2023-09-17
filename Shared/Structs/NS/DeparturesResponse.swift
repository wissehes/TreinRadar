//
//  DeparturesResponse.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import Foundation

// MARK: DeparturesResponse
struct DeparturesResponse: Codable {
    let payload: DeparturesPayload
    let links: Links?
    let meta: Meta?
}

// MARK: - Links
struct Links: Codable {
    let disruptions: Disruptions
}

// MARK: - Disruptions
struct Disruptions: Codable {
    let uri: String
}

// MARK: - Meta
struct Meta: Codable {
    let numberOfDisruptions: Int
}

// MARK: - DeparturesPayload
struct DeparturesPayload: Codable {
    let source: String
    let departures: [Departure]
}

// MARK: Departure
struct Departure: Codable, Hashable {
    static func == (lhs: Departure, rhs: Departure) -> Bool {
        lhs.name == rhs.name
    }
    
    enum DepartureStatus: String, Codable {
        case onStation = "ON_STATION"
        case incoming = "INCOMING"
        case departed = "DEPARTED"
        case unknown = "UNKNOWN"
    }
    
    let direction, name: String
    let plannedDateTime: Date
    let plannedTimeZoneOffset: Int
    let actualDateTime: Date
    let actualTimeZoneOffset: Int
    let plannedTrack, actualTrack: String?
    let product: Product
    let trainCategory: String
    let cancelled: Bool
    let routeStations: [RouteStation]
    let messages: [Message]
    let departureStatus: DepartureStatus?
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

// MARK: - RouteStation
struct RouteStation: Codable, Hashable {
    let uicCode, mediumName: String
}
