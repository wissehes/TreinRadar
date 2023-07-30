//
//  SavedJourney.swift
//  TreinRadar
//
//  Created by Wisse Hes on 30/07/2023.
//

import Foundation
import Defaults

enum SavedJourneyError: LocalizedError {
    case noJourneyCode
    case noStartInfo
    case noEndInfo
    
    var errorDescription: String? {
        switch self {
        case .noJourneyCode:
            return "Geen reis-code gevonden."
        case .noStartInfo:
            return "Geen startstation gevonden."
        case .noEndInfo:
            return "Geen eindstation gevonden."
        }
    }
}


struct SavedJourney: Codable, Identifiable, Defaults.Serializable, Journey {
    var id: String {
        self.code
    }
    var journeyId: String {
        self.code
    }
    
    let code: String
    
    /// Start of journey
    let start: StopInfo
    let startDate: Date?
    
    /// End of journey
    let end: StopInfo
    let endDate: Date?
    
    init(code: String, start: StopInfo, startDate: Date?, end: StopInfo, endDate: Date?) {
        self.code = code
        self.start = start
        self.startDate = startDate
        self.end = end
        self.endDate = endDate
    }
    
    init(journey: JourneyPayload) throws {
        guard let code = journey.productNumbers.first else { throw SavedJourneyError.noJourneyCode }
        self.code = code
        
        guard let start = journey.stops.first?.stop else { throw SavedJourneyError.noStartInfo }
        self.start = start
        self.startDate = journey.stops.first?.departure?.plannedTime
        
        guard let end = journey.stops.last?.stop else { throw SavedJourneyError.noEndInfo }
        self.end = end
        self.endDate = journey.stops.last?.arrival?.plannedTime
    }
    
}
