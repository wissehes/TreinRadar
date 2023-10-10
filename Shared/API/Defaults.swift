//
//  Defaults.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let suite = UserDefaults(suiteName: "group.nl.wissehes.TreinRadar")!
    
    static let favouriteStations = Key<[SavedStation]>("favourite-stations", default: [], suite: suite)
    static let savedJourneys = Key<[SavedJourney]>("saved-journeys", default: [], suite: suite)
    
    /// Whether the trains map should automatically refresh
    static let trainsShouldRefetch = Key<Bool>("trains-should-refetch", default: true, suite: suite)
    
    /// Whether to rotate the train icons on the train map in their direction
    static let rotateTrainIcons = Key<Bool>("rotate-train-icons", default: true, suite: suite)
}
