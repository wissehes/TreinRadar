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
    
    func setData(data: JourneyPayload) async {
        DispatchQueue.main.async {
            withAnimation {
                self.journey = data
            }
        }
    }
    
    func load(stock: String) async {
        defer {
            DispatchQueue.main.async {
                withAnimation {
                    self.isLoading = false
                }
            }
        }
        
        do {
            let journeyId = try await API.shared.getJourneyFromStock(stock)
            let journey = try await API.shared.getJourney(journeyId: journeyId)
            await self.setData(data: journey)
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
            }
        }
    }
    
    var trainLength: Int? {
        journey?.firstRealStop?.actualStock?.numberOfParts
    }
    
    var numberOfSeats: Int? {
        journey?.firstRealStop?.actualStock?.numberOfSeats
    }
    
    /// All stops except the stations the train has already passed
    var nextStops: [Stop] {
        guard let stops = self.journey?.stops else { return [] }

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
        journey?.stops.filter { $0.status != .passing } ?? []
    }
    
    /// Stops visible on screen
    var stops: [Stop] {
        showingPreviousStops ? allStops : nextStops
    }
}
