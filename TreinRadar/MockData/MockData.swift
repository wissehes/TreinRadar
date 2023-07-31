//
//  MockData.swift
//  TreinRadar
//
//  Created by Wisse Hes on 05/07/2023.
//

import Foundation

final class MockData {
    
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    
    enum MockDataError: Error {
        case resourceError
        case dataError
        case decodingError
    }
    
    
    init() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder
    }
    
    func getData<T>(resource: String, type: T.Type) throws -> T where T : Decodable {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            throw MockDataError.resourceError
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            throw MockDataError.dataError
        }
        guard let decoded = try? self.decoder.decode(type.self, from: data) else {
            throw MockDataError.decodingError
        }
        return decoded
    }
}
