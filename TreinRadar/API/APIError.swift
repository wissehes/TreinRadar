//
//  APIError.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import Foundation

enum APIError: Error {
    case noTrainsReturned
    case noGeoJsonData
}
