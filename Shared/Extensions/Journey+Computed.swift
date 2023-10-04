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
        self.stops.filter({ $0.status != .passing && $0.status != .unknown })
    }
    
    /// First stop that includes an actual departure date.
    var firstRealStop: Stop? {
        return self.stops.first(where: { $0.departure != nil })
    }
    
    /// Either the current stop, or the next stop.
    var currentOrNextStop: Stop? {
        let currentStop = actualStops.first { stop in
            guard let arrivalTime = stop.arrival?.actualTime else { return false }
            
            // If there's a departure time present, compare whether
            // this item is the current stop.
            if let departureTime = stop.departure?.actualTime {
                return Date.now > arrivalTime && Date.now < departureTime
            } else {
                // If there's no departure time, check whether this item is the last one.
                // And that the arrival time is in the past
                return actualStops.last?.id == stop.id && Date.now > arrivalTime
            }
        }
        
        // If the current stop was found, return it
        if let currentStop = currentStop { return currentStop }
        // Otherwise, let's search for the next stop
        
        let nextStop = actualStops.first { stop in
            // Make sure the arrival time is present
            guard let arrivalTime = stop.arrival?.actualTime else { return false }
            
            // Check whether the arrival time is in the future.
            // The next station is always the first one in the future.
            return arrivalTime > Date.now
        }
        
        return nextStop
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
