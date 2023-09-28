//
//  TrainManager.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation
import CoreLocation
import SwiftUI

final class TrainManager: ObservableObject {
    
    static let shared = TrainManager()

    @Published var trains: [Train] = []
    
    @Published var currentTrain: TrainWithDistance?
    @Published var currentJourney: JourneyPayload?
    
    @Published var updateTrains = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    /// Stops the `updateTrains` timer
    func stopTimer() {
        updateTrains.upstream.connect().cancel()
    }
    
    /// Restarts the `updateTrains` timer.
    func restartTimer() {
        self.updateTrains = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    }
    
    // TODO: Rename this to `updateData` as that would be more clear
    func getData() async {
        print("Getting trains...")
        do {
            let data = try await API.shared.getLiveTrains()
            DispatchQueue.main.async { withAnimation { self.trains = data } }
        } catch { print(error) }
    }
    
    /// Get a specific train by journey ID
    func getTrain(_ journeyId: String) -> Train? {
        return trains.first { $0.ritID == journeyId }
    }
    
    func getCurrentJourney(location myLocation: CLLocation) async {
        await self.getData()
        guard !self.trains.isEmpty else { return }
        let trains = self.trains
        
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
