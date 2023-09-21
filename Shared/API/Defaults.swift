//
//  Defaults.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation
import Defaults

extension Defaults.Keys {
    private static let suite = UserDefaults(suiteName: "nl.wissehes.TreinRadar")!
    
    static let favouriteStations = Key<[SavedStation]>("favourite-stations", default: [], suite: suite)
    static let savedJourneys = Key<[SavedJourney]>("saved-journeys", default: [], suite: suite)
}
