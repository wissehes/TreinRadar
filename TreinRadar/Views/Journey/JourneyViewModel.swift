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
    
//    var actualStops: [Stop]? {
//        guard let stops = journey?.stops else { return nil }
//        if showAllStops {
//            return stops
//        } else {
//            return stops.filter({ $0.status != .passing })
//        }
//    }
//    
//    var firstRealStop: Stop? {
//        guard let journey = journey else { return nil }
//        return journey.stops.first(where: { $0.departure != nil })
//    }
//    
//    var product: Product? {
//        guard let departure = firstRealStop?.departure else { return nil }
//        return departure.product
//    }
//    
//    var destination: StopInfo? {
//        let firstTry = self.firstRealStop?.departure?.destination
//        let secondTry = journey?.stops.last?.stop
//        
//        return firstTry ?? secondTry ?? nil
//    }
//    
//    var stockNumbers: String {
//        guard let parts = self.firstRealStop?.actualStock?.trainParts else { return "0" }
//        let mapped = parts.map({ $0.stockIdentifier })
//        return mapped.joined(separator: ", ")
//    }
//    
//    var category: String {
//        return product?.longCategoryName ?? "Trein"
//    }
    
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
