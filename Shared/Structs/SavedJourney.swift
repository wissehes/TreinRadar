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

/**
 Configuration for following a journey with a live activity
 */
struct JourneyLiveActivitySettings: Codable, Hashable {
    let startStation: StopInfo
    let endStation: StopInfo
    
    /// Whether to notifiy the user for each stop
    let notifyForEachStop: Bool
    
    /// Amount of minutes before arrival to send a notification
    let arrivalNotification: Int
}


struct SavedJourney: Codable, Identifiable, Defaults.Serializable, Journey, Hashable {
    var id: String {
        var id = self.code
        
        if let startDate = startDate {
            id.append("-\(startDate.ISO8601Format())")
        }
        if let endDate = endDate {
            id.append("-\(endDate.ISO8601Format())")
        }
        
        return id
    }
    var journeyId: String {
        self.code
    }
    
    let code: String
    let saved: Date
    
    /// Start of journey
    let start: StopInfo
    let startDate: Date?
    
    /// End of journey
    let end: StopInfo
    let endDate: Date?
    
    /// Product info
    let product: Product?
    
    let liveActivity: JourneyLiveActivitySettings?
    
    init(code: String, created: Date, start: StopInfo, startDate: Date?, end: StopInfo, endDate: Date?, product: Product?, liveActivity: JourneyLiveActivitySettings? = nil) {
        self.code = code
        self.saved = created
        self.start = start
        self.startDate = startDate
        self.end = end
        self.endDate = endDate
        self.product = product
        self.liveActivity = liveActivity
    }
    
    init(journey: JourneyPayload, liveActivity: JourneyLiveActivitySettings? = nil) throws {
        guard let code = journey.productNumbers.first else { throw SavedJourneyError.noJourneyCode }
        self.code = code
        self.saved = .now
        
        guard let start = journey.stops.first?.stop else { throw SavedJourneyError.noStartInfo }
        self.start = start
        self.startDate = journey.stops.first?.departure?.plannedTime
        
        guard let end = journey.stops.last?.stop else { throw SavedJourneyError.noEndInfo }
        self.end = end
        self.endDate = journey.stops.last?.arrival?.plannedTime
        
        self.product = journey.product
        self.liveActivity = liveActivity
    }
    
}
