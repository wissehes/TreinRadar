//
//  TravelInfoViewModel.swift
//  TreinRadar
//
//  Created by Wisse Hes on 26/06/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import Alamofire

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
    @Published var presentedJourneys = NavigationPath()
    
    @Published var currentTrain: TrainWithDistance?
    @Published var currentJourney: JourneyPayload?
    
    @Published var errorVisible = false
    @Published var error: AFError?
    
    @MainActor
    func getJourneyId() async {
        if stockNumber.isEmpty { return }
        
        defer { self.isLoading = false }
        
        self.isLoading = true
        
        do {
            let id = try await API.shared.getJourneyFromStock(stockNumber)
            withAnimation {
                self.presentedJourneys.append(id)
            }
        } catch let error as AFError {
            self.error = error
            self.errorVisible = true
            print(error)
        } catch {
            print(error)
        }
    }
    
}
