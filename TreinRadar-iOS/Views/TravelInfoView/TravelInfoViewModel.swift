//
//  TravelInfoViewModel.swift
//  TreinRadar
//
//  Created by Wisse Hes on 26/06/2023.
//

import Foundation
import SwiftUI
import CoreLocation

struct TrainWithDistance {
    let train: Train
    
    var location: CLLocation
    var distance: Double
    
    var formattedDistance: String {
        let distanceInMeters = Measurement(value: self.distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter.myFormatter
        
        return formatter.string(from: distanceInMeters)
    }
    
    init(_ train: Train, location: CLLocation, distance: Double) {
        self.train = train
        self.location = location
        self.distance = distance
    }
}

final class TravelInfoViewModel: ObservableObject {
    
    @Published var stockNumber = ""
    @Published var isLoading = false
    @Published var presentedJourneys: [JourneyId] = []
    
    @Published var currentTrain: TrainWithDistance?
    @Published var currentJourney: JourneyPayload?
    
    
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
