//
//  StationsResponse.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import Foundation
import MapKit

struct StationsResponse: Codable {
    let payload: [FullStation]
}

// MARK: FullStation
struct FullStation: Codable, Station, Hashable, Identifiable {
    let uicCode: String
    let stationType: StationType
    let evaCode, code: String
    let sporen: [Spoor]
    let synoniemen: [String]
    let heeftFaciliteiten, heeftVertrektijden, heeftReisassistentie: Bool
    let namen: Namen
    let land: Land
    let lat, lng: Double
    let radius, naderenRadius: Int
    let ingangsDatum: String
    let nearbyMeLocationID: NearbyMeLocationID
    
    static func == (lhs: FullStation, rhs: FullStation) -> Bool {
        lhs.code == rhs.code
    }
    
    var id: String {
        return self.code
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
    
    var name: String {
        return self.namen.lang
    }

    enum CodingKeys: String, CodingKey {
        case uicCode = "UICCode"
        case stationType
        case evaCode = "EVACode"
        case code, sporen, synoniemen, heeftFaciliteiten, heeftVertrektijden, heeftReisassistentie, namen, land, lat, lng, radius, naderenRadius, ingangsDatum
        case nearbyMeLocationID = "nearbyMeLocationId"
    }
}

enum Land: String, Codable {
    case a = "A"
    case b = "B"
    case ch = "CH"
    case d = "D"
    case dk = "DK"
    case f = "F"
    case gb = "GB"
    case i = "I"
    case nl = "NL"
    case s = "S"
}

// MARK: - Spoor
struct Spoor: Codable, Hashable {
    let spoorNummer: String
}

// MARK: - Namen
struct Namen: Codable, Hashable {
    let lang, middel, kort: String
}

// MARK: - NearbyMeLocationID
struct NearbyMeLocationID: Codable, Hashable {
    let value: String
    let type: String
}

enum StationType: String, Codable {
    case facultatiefStation = "FACULTATIEF_STATION"
    case intercityStation = "INTERCITY_STATION"
    case knooppuntIntercityStation = "KNOOPPUNT_INTERCITY_STATION"
    case knooppuntSneltreinStation = "KNOOPPUNT_SNELTREIN_STATION"
    case knooppuntStoptreinStation = "KNOOPPUNT_STOPTREIN_STATION"
    case megaStation = "MEGA_STATION"
    case sneltreinStation = "SNELTREIN_STATION"
    case stoptreinStation = "STOPTREIN_STATION"
}
