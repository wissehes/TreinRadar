//
//  JourneyViewModel.swift
//  TreinRadar
//
//  Created by Wisse Hes on 22/06/2023.
//

import Foundation
import Defaults

final class JourneyViewModel: ObservableObject {
    @Published var journey: JourneyPayload?
    @Published var geojson: StopsAndGeometry?
    @Published var showAllStops: Bool = false
    @Published var showingPreviousStops: Bool = false
    
    var stops: [Stop]? {
        return showAllStops ? journey?.stops : journey?.actualStops
    }
    
    /// All stops except the stations the train has already passed
    var currentStops: [Stop]? {
        guard let stops = self.stops else { return nil }

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
    
    /// Stops visible on screen
    var showingStops: [Stop]? {
        return showingPreviousStops ? stops : currentStops
    }
    
    /// Toggle whether the journey is saved
    func toggleSave() {
        guard let journey = self.journey else { return }
        guard let code = journey.productNumbers.first else { return }
        
        if Defaults[.savedJourneys].first(where: { $0.code == code }) != nil {
            Defaults[.savedJourneys].removeAll(where: { $0.code == code })
        } else {
            
            do {
                let save = try SavedJourney(journey: journey)
                Defaults[.savedJourneys].append(save)
            } catch {
                print(error)
            }
            
        }
    }
    
    func getData(_ journeyId: String) async {
        do {
            let data = try await API.shared.getJourney(journeyId: journeyId)
            await getGeojson(data.stops, journeyId: journeyId)
            DispatchQueue.main.async { self.journey = data }
        } catch { print(error) }
    }
    
    func getGeojson(_ stops: [Stop], journeyId: String) async {
        do {
            let data = try await API.shared.getJourneyGeoJson(stops: stops, journeyId: journeyId)
            DispatchQueue.main.async { self.geojson = data }
        } catch { print(error) }
    }
}
