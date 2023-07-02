//
//  TravelInfoViewModel.swift
//  TreinRadar
//
//  Created by Wisse Hes on 26/06/2023.
//

import Foundation
import SwiftUI

final class TravelInfoViewModel: ObservableObject {
    
    @Published var stockNumber = ""
    @Published var isLoading = false
    @Published var presentedJourneys: [JourneyId] = []
    
    func getJourneyId() async {
        if stockNumber.isEmpty { return }
        
        DispatchQueue.main.async { self.isLoading = true }
        do {
            let id = try await API.shared.getJourneyFromStock(stockNumber)
            DispatchQueue.main.async {
                withAnimation {
                    self.isLoading = false
                    self.presentedJourneys.append(id)
                }
            }
        } catch { print(error) }
    }
    
}
