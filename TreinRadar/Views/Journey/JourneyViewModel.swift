//
//  JourneyViewModel.swift
//  TreinRadar
//
//  Created by Wisse Hes on 22/06/2023.
//

import Foundation

final class JourneyViewModel: ObservableObject {
    @Published var journey: JourneyPayload?
    @Published var geojson: StopsAndGeometry?
    @Published var showAllStops: Bool = false
    
    var stops: [Stop]? {
        return showAllStops ? journey?.stops : journey?.actualStops
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
