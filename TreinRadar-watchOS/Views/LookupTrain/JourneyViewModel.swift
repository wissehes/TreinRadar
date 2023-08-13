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
    
    var stops: [Stop] {
        journey?.stops.filter { $0.status != .passing } ?? []
    }
}
