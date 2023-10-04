//
//  JourneyResponse.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation
import MapKit

// MARK: - JourneyResponse
struct JourneyResponse: Codable {
    let payload: JourneyPayload
}

// MARK: - Payload
struct JourneyPayload: Codable, Equatable {
    static func == (lhs: JourneyPayload, rhs: JourneyPayload) -> Bool {
        lhs.productNumbers == rhs.productNumbers
    }
    
    let notes: [JourneyNote]
    let productNumbers: [String]
    let stops: [Stop]
    let allowCrowdReporting: Bool
    let source: String
}

// MARK: - JourneyNote
struct JourneyNote: Codable {
    let text, type: String
    let noteType: NoteType
}

// MARK: - Stop
struct Stop: Codable {
    let id: String
    let stop: StopInfo
    let previousStopID, nextStopID: [String]
    let destination: String?
    let status: StopStatus
    let arrivals, departures: [ArrivalOrDeparture]
    let actualStock, plannedStock: Stock?
//    let platformFeatures, coachCrowdForecast: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id, stop
        case previousStopID = "previousStopId"
        case nextStopID = "nextStopId"
        case destination, status, arrivals, departures, actualStock, plannedStock
        // platformFeatures, coachCrowdForecast
    }
}

// MARK: - Stock
struct Stock: Codable {
    let trainType: String?
    let numberOfSeats, numberOfParts: Int?
    let trainParts: [TrainPart]
    let hasSignificantChange: Bool
}

// MARK: - TrainPart
struct TrainPart: Codable {
    let stockIdentifier: String
    let facilities: [Facility]
    let image: TrainImage?
}

enum Facility: String, Codable {
    case fiets = "FIETS"
    case stilte = "STILTE"
    case stroom = "STROOM"
    case toegankelijk = "TOEGANKELIJK"
    case toilet = "TOILET"
    case wifi = "WIFI"
}

// MARK: - TrainImage
struct TrainImage: Codable, Hashable {
    let uri: String
}

// MARK: - ArrivalOrDeparture
struct ArrivalOrDeparture: Codable {
    let product: Product
    let origin: StopInfo
    let destination: StopInfo?
    let plannedTime, actualTime: Date?
    let delayInSeconds: Int?
    let plannedTrack, actualTrack: String?
    let cancelled: Bool
    let crowdForecast: CrowdForecast?
    let stockIdentifiers: [String]?
    let punctuality: Double?
}

enum CrowdForecast: String, Codable {
    case low = "LOW"
    case medium = "MEDIUM"
    case HIGH = "HIGH"
    case unknown = "UNKNOWN"
}

// MARK: - StopInfo
struct StopInfo: Codable, Hashable {
    let name: String
    let lng, lat: Double
    let countryCode: String
    let uicCode: String
    
    var coordinates: CLLocationCoordinate2D {
        return .init(latitude: self.lat, longitude: self.lng)
    }
}

enum StopStatus: String, Codable {
    case destination = "DESTINATION"
    case origin = "ORIGIN"
    case passing = "PASSING"
    case stop = "STOP"
    case unknown = "UNKNOWN"
}

// MARK: NoteType
enum NoteType: String, Codable {
    case unknown = "UNKNOWN"
    case attribute = "ATTRIBUTE"
    case infotext = "INFOTEXT"
    case realtime = "REALTIME"
    case ticket = "TICKET"
    case hint = "HINT"
}
