//
//  TrainManager.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation
import CoreLocation
import SwiftUI
import Alamofire

typealias TrainWithDistance = (LiveTrain, Double)

/// Train detection state
enum TrainDetectionState: Equatable {
    static func == (lhs: TrainDetectionState, rhs: TrainDetectionState) -> Bool {
        lhs.value == rhs.value
    }
    
    /// We're detecting a train...
    case detecting
    /// A train was found
    case train(DetectedTrain)
    /// No train was detected
    case noTrainDetected
    /// An error occurred
    case error(AFError?)
    
    var value: String {
        switch self {
        case .detecting:
            return "Detecting..."
        case .train(let detectedTrain):
            return "Found train: \(detectedTrain.journey.productNumbers.first ?? "?")"
        case .noTrainDetected:
            return "No train detected"
        case .error(let error):
            if let error = error {
                return "An error ocurred: \(error.localizedDescription)"
            } else {
                return "An error ocurred."
            }
        }
    }
    
}

final class TrainManager: ObservableObject {
    
    static let shared = TrainManager()

    @Published var trains: [LiveTrain] = []
    @Published var trainDetection: TrainDetectionState = .detecting
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
            DispatchQueue.main.async { self.trains = data }
        } catch { print(error) }
    }
    
    @MainActor
    private func setDetectionState(_ state: TrainDetectionState) {
        self.trainDetection = state
    }
    
    func detectTrain(location myLocation: CLLocation) async {
        await self.getData()
        guard !self.trains.isEmpty else { return }
        
        // Calculate distance to each train and then sort by distance.
        let nearbyTrains: [TrainWithDistance] = trains.map { train in
            let location = train.location
            let distance = myLocation.distance(from: location)
//            return .init(train, location: location, distance: distance)
            return (train, distance)
        }.sorted { $0.1 < $1.1 }
        
        /// Get the first train, the one closest by the user
        guard let currentTrain = nearbyTrains.first else {
            await setDetectionState(.noTrainDetected)
            return
        }
        
        /// Make sure that the current train is less than 500 meters away.
        guard currentTrain.1 < 500 else {
            await setDetectionState(.noTrainDetected)
            return
        }
        
        // Fetch the current journey and set the state.
        do {
            let currentJourney = try await API.shared.getJourney(journeyId: currentTrain.0.journeyId)
            let detectedTrain = DetectedTrain(train: currentTrain, journey: currentJourney)
            
            await setDetectionState(.train(detectedTrain))
        } catch let error as AFError {
            await setDetectionState(.error(error))
        } catch { print(error) }
    }
}
