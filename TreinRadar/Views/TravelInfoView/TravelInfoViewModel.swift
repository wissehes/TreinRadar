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
    
    init() {
        LocationManager.shared.requestLocation()
    }
    
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
    
    func getCurrentJourney() async {
        await TrainManager.shared.getData()
        guard !TrainManager.shared.trains.isEmpty else { return }
        guard let myLocation = LocationManager.shared.location else { return }
        let trains = TrainManager.shared.trains
        
        let mapped: [TrainWithDistance] = trains.map { train in
            let location = CLLocation(latitude: train.lat, longitude: train.lng)
            let distance = myLocation.distance(from: location)
            return .init(train, location: location, distance: distance)
        }
        
        let sorted = mapped.sorted { $0.distance < $1.distance }
        
        guard let currentTrain = sorted.first else { return }
        guard let currentJourney = try? await API.shared.getJourney(journeyId: currentTrain.train.ritID) else { return }
        
        DispatchQueue.main.async {
            self.currentTrain = currentTrain
            self.currentJourney = currentJourney
        }
    }
    
}
