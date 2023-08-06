//
//  API.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import Foundation
import Alamofire
import CoreLocation

typealias JourneyId = String

final class Endpoints {
    static let currentVehicles = "\(API.baseURL)/virtual-train-api/api/vehicle";
    static let trainsInfo = "\(API.baseURL)/virtual-train-api/api/v1/trein"
    
    static let stations = "\(API.baseURL)/reisinformatie-api/api/v2/stations"
    static let departures = "\(API.baseURL)/reisinformatie-api/api/v2/departures"
    
    static let journey = "\(API.baseURL)/reisinformatie-api/api/v2/journey"
    static let journeyGeojson = "\(API.baseURL)/Spoorkaart-API/api/v1/traject.json"
    static let journeyFromStock = "\(API.baseURL)/virtual-train-api/api/v1/ritnummer"
    
    static let myBackend = "https://trein.wissehes.nl/api"
    static let nearbyTrains = "https://trein.wissehes.nl/api/trains/nearby"
}

final class API {
    static let shared = API();
    
    static let baseURL = "https://gateway.apiportal.ns.nl";
    static private let API_KEY = "eebce6e00cff4ca286eb667f120f3cb2";
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    let client: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.httpAdditionalHeaders = [ "Ocp-Apim-Subscription-Key": API_KEY ];

        return Session(configuration: configuration);
    }()
    
    /// Get all live trains
    func getLiveTrains() async throws -> [Train] {
        let data = try await client.request(Endpoints.currentVehicles).serializingDecodable(CurrentVehicles.self).value
        return data.payload.treinen
    }
    
    /// Get a single live train
    func getLiveTrainData(journeyId: String) async throws -> Train {
        let data = try await client.request("\(Endpoints.myBackend)/trains/\(journeyId)/live")
            .serializingDecodable(Train.self)
            .value
        
        return data
    }
    
    func getStations() async throws -> [FullStation] {
        let data = try await client.request(Endpoints.stations).serializingDecodable(StationsResponse.self).value
        return data.payload
    }
    
    func getDepartures(stationCode: String) async throws -> [Departure] {
        let params: Parameters = [
            "station": stationCode
        ]
        
        let data = try await client
            .request(Endpoints.departures, parameters: params)
            .serializingDecodable(DeparturesResponse.self, decoder: decoder)
            .value
        return data.payload.departures
    }
    
    func getJourney(journeyId: String) async throws -> JourneyPayload {
        let params: Parameters = [
            "features": ["zitplaats", "platformitems", "cta", "drukte"].joined(separator: ","),
            "train": journeyId
        ]
        
        let data = try await client
            .request(Endpoints.journey, parameters: params)
            .serializingDecodable(JourneyResponse.self, decoder: decoder)
            .value
        return data.payload
    }
    
    func getJourneyGeoJson(stops: [Stop], journeyId: String) async throws -> StopsAndGeometry {
        let mappedStations = stops.map { $0.id.replacingOccurrences(of: "_0", with: "") }
        let params: Parameters = [
            "stations": mappedStations.joined(separator: ",")
        ]
        
        let data = try await client
            .request(Endpoints.journeyGeojson, parameters: params)
            .serializingDecodable(JourneyGeojsonResponse.self)
            .value
        
        guard let feature = data.payload.features.first else { throw APIError.noGeoJsonData }
        
        let stopsAndGeometry = StopsAndGeometry(
            id: journeyId,
            stops: stops.filter({ $0.status != .passing }).map({ $0.stop }),
            coordinates: feature.geometry.coordinates
        )
        return stopsAndGeometry
    }
    
    func getJourneyFromStock(_ stockNumber: String) async throws -> JourneyId {
        let journeyId = try await client
            .request("\(Endpoints.journeyFromStock)/\(stockNumber)")
            .serializingString()
            .value
        
        return journeyId
    }
    
    func getNearbyTrains(location: CLLocation) async throws -> [NearbyTrain] {
        let params: Parameters = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "radius": 10000
        ]
        
        let data = try await client
            .request(Endpoints.nearbyTrains, parameters: params)
            .serializingDecodable([NearbyTrain].self)
            .value
        
        return data
    }
    
}
