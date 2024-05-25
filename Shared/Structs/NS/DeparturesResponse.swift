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
struct Departure: Codable, Hashable, TimeTableItem {
    
    static func == (lhs: Departure, rhs: Departure) -> Bool {
        lhs.name == rhs.name
    }
    
    let direction: String
    let name: String
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
    let departureStatus: TimeTableStatus?
    
    var type: TimeTableType {
        .departure
    }
    var status: TimeTableStatus {
        self.departureStatus ?? .unknown
    }
    var station: String {
        self.direction
    }
}

// MARK: - RouteStation
struct RouteStation: Codable, Hashable {
    let uicCode, mediumName: String
}
