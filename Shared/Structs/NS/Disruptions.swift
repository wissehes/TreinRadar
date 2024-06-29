//
//  Disruptions.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2024.
//

import Foundation

// MARK: - Disruption
struct Disruption: Codable, Identifiable {
    let type: DisruptionType
    let id, title: String
    let isActive: Bool
    let topic: String?
    let local: Bool?
    let titleSections: [[TitleSection]]?
    let registrationTime, releaseTime, start, end: Date?
    let phase: Phase?
    let impact: Impact?
    let expectedDuration: ExpectedDuration?
    let publicationSections: [PublicationSection]?
    let summaryAdditionalTravelTime: AdditionalTravelTime?
    let timespans: [Timespan]?
    let alternativeTransportTimespans: [AlternativeTransportTimespan]?
    let description: String?
    let url: String?
    let priority: String?
    let lastUpdated: Date?
    let bodyItems: [BodyItem]?
    let buttons: Buttons?
    let period: String?
    
    // MARK: - AlternativeTransportTimespan
    struct AlternativeTransportTimespan: Codable {
        let start, end: Date
        let alternativeTransport: AlternativeTransportTimespanAlternativeTransport
    }

    // MARK: - AlternativeTransportTimespanAlternativeTransport
    struct AlternativeTransportTimespanAlternativeTransport: Codable {
        let location: [Location]
        let label, shortLabel: String
    }

    // MARK: - Location
    struct Location: Codable {
        let station: DisruptionStation
        let description: String
    }

    // MARK: - DisruptionStation
    struct DisruptionStation: Codable {
        let coordinate: Coordinate
        let countryCode: CountryCode
        let name, stationCode, uicCode: String
    }

    // MARK: - Coordinate
    struct Coordinate: Codable {
        let lat, lng: Double
    }

    enum CountryCode: String, Codable {
        case a = "A"
        case b = "B"
        case d = "D"
        case f = "F"
        case gb = "GB"
        case nl = "NL"
    }

    // MARK: - BodyItem
    struct BodyItem: Codable {
        let type: String
        let content: Content
    }

    // MARK: - Content
    struct Content: Codable {
        let text: String
    }

    // MARK: - Buttons
    struct Buttons: Codable {
        let position: [String]
        let items: [Item]
    }

    // MARK: - Item
    struct Item: Codable {
        let label, accessibilityLabel: String
        let url: String
        let type: String
    }

    // MARK: - ExpectedDuration
    struct ExpectedDuration: Codable {
        let description: String
        let endTime: Date
    }

    // MARK: - Impact
    struct Impact: Codable {
        let value: Int
    }

    // MARK: - Phase
    struct Phase: Codable {
        let id, label: String
    }

    // MARK: - PublicationSection
    struct PublicationSection: Codable {
        let section: DisruptionSection
        let consequence: Consequence
        let sectionType: SectionType
    }

    // MARK: - Consequence
    struct Consequence: Codable {
        let section: DisruptionSection
        let description: String
    //    let level: Level
        let level: String
    }

    //enum Level: String, Codable {
    //    case lessTrains = "LESS_TRAINS"
    //}

    // MARK: - DisruptionSection
    struct DisruptionSection: Codable {
        let stations: [DisruptionStation]
    //    let direction: Direction
        let direction: String
    }

    //enum Direction: String, Codable {
    //    case both = "BOTH"
    //    case oneWay = "ONE_WAY"
    //}

    enum SectionType: String, Codable {
        case hsl = "HSL"
        case neighboringCountry = "NEIGHBORING_COUNTRY"
        case nl = "NL"
    }

    // MARK: - AdditionalTravelTime
    struct AdditionalTravelTime: Codable {
        let label: String
        let shortLabel: String
        let maximumDurationInMinutes, minimumDurationInMinutes: Int?
    }

    // MARK: - Timespan
    struct Timespan: Codable {
        let start, end: Date
        let situation, cause: Cause
        let additionalTravelTime: AdditionalTravelTime?
        let advices: [String]
        let period: String?
        let alternativeTransport: TimespanAlternativeTransport?
    }

    // MARK: - TimespanAlternativeTransport
    struct TimespanAlternativeTransport: Codable {
        let label: String
        let shortLabel: String
    }

    // MARK: - Cause
    struct Cause: Codable {
        let label: String
    }

    // MARK: - TitleSection
    struct TitleSection: Codable, Hashable, Identifiable {
        var id: String {
            type.rawValue + value
        }
        
        let type: TitleSectionType
        let value: String
    }

    enum TitleSectionType: String, Codable {
        case icon = "ICON"
        case station = "STATION"
    }

    enum DisruptionType: String, Codable {
        case calamity = "CALAMITY"
        case disruption = "DISRUPTION"
        case maintenance = "MAINTENANCE"
    }
}

typealias Disruptions = [Disruption]
