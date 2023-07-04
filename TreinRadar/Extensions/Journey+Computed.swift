//
//  Journey+Computed.swift
//  TreinRadar
//
//  Created by Wisse Hes on 03/07/2023.
//

import Foundation

/// Computed variables for a journey.
extension JourneyPayload {
    
    /// Stops where the train actually stops.
    var actualStops: [Stop] {
        self.stops.filter({ $0.status != .passing })
    }
    
    /// First stop that includes an actual departure date.
    var firstRealStop: Stop? {
        return self.stops.first(where: { $0.departure != nil })
    }
    
    /// The product of the journey
    var product: Product? {
        self.firstRealStop?.departure?.product
    }
    
    /// The destination
    var destination: StopInfo? {
        let firstTry = self.firstRealStop?.departure?.destination
        let secondTry = self.stops.last?.stop
        
        return firstTry ?? secondTry ?? nil
    }
    
    /// The stock numbers of the train(s) on the journey.
    var stockNumbers: String {
        guard let parts = self.firstRealStop?.actualStock?.trainParts else { return "0" }
        let mapped = parts.map({ $0.stockIdentifier })
        return mapped.joined(separator: ", ")
    }
    
    /// Simplified category
    var category: String {
        self.product?.longCategoryName ?? "Rit"
    }
}
