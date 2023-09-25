//
//  JourneyViewModel.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 13/08/2023.
//

import Foundation
import SwiftUI

final class JourneyViewModel: ObservableObject {
    @Published var journey: JourneyPayload?
    @Published var isLoading = true
    @Published var error: String?
    
    @Published var showingPreviousStops = false
    
    /// Helper function for setting the data with an animation
    @MainActor
    func setData(data: JourneyPayload) {
        withAnimation {
            self.journey = data
        }
    }
    
    @MainActor
    func load(identifier: JourneyIdentifier) async {
        defer {
            withAnimation {
                self.isLoading = false
            }
        }
        
        do {
            switch identifier {
            case .journeyId(let journeyId):
                let journey = try await API.shared.getJourney(journeyId: journeyId)
                self.setData(data: journey)
            case .stockNumber(let stock):
                let journeyId = try await API.shared.getJourneyFromStock(stock)
                let journey = try await API.shared.getJourney(journeyId: journeyId)
                self.setData(data: journey)
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    /// Amount of parts this train has
    var trainLength: Int? {
        journey?.firstRealStop?.actualStock?.numberOfParts
    }
    
    /// The amount of seats this train has
    var numberOfSeats: Int? {
        journey?.firstRealStop?.actualStock?.numberOfSeats
    }
    
    /// All stops except the stations the train has already passed
    var nextStops: [Stop] {
        guard let stops = self.journey?.actualStops else { return [] }
        
        let nextStopIndex = stops.firstIndex(where: {
            if let date = $0.departure?.actualTime ?? $0.arrival?.actualTime {
                return date > Date.now
            } else {
                return false
            }
        })
        
        guard let index = nextStopIndex else { return stops }
        
        return Array(stops.suffix(from: index.toNative()))
    }
    
    /// All stops this train calls at
    var allStops: [Stop] {
        journey?.actualStops ?? []
    }
    
    /// Stops visible on screen
    var stops: [Stop] {
        showingPreviousStops ? allStops : nextStops
    }
}
