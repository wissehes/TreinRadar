//
//  Defaults.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let favouriteStations = Key<[SavedStation]>("favourite-stations", default: [])
    static let savedJourneys = Key<[String]>("saved-journeys", default: [])
}
