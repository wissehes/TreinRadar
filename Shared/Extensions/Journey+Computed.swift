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
        self.stops.filter({
            $0.status != .passing &&
            $0.status != .unknown //&&
//            $0.departure?.destination != nil
//            ($0.departure?.actualTime != nil || $0.arrival?.actualTime != nil)
        })
    }
    
    /// First stop that includes an actual departure date.
    var firstRealStop: Stop? {
        return self.stops.first(where: { $0.departure != nil })
    }
    
    /// Current stop. If available
    var currentStop: Stop? {
        actualStops.first { stop in
            let arrivalTime = stop.arrival?.actualTime
            let departureTime = stop.departure?.actualTime
            
            // If the departure and arrival times are present, check whether
            // the arrival time is in the past and the departure time in the future.
            if let departureTime = departureTime, let arrivalTime = arrivalTime {
                return Date.now >= arrivalTime && Date.now <= departureTime
                
            } else if let departureTime = departureTime {
                // If there's only a departure time, check whether this is the first item,
                // and that the departure time is in the future
                return actualStops.first?.id == stop.id && departureTime >= Date.now
                
            } else if let arrivalTime = arrivalTime {
                // If there's no departure time, check whether this item is the last one.
                // And that the arrival time is in the past
                return actualStops.last?.id == stop.id && Date.now >= arrivalTime
                
            } else {
                return false
            }
        }
    }
    
    /// The next stop, based on arrival time.
    var nextStop: Stop? {
        actualStops.sorted(by: { a, b in
            guard let timeA = a.arrival?.actualTime, let timeB = a.arrival?.actualTime else { return false }
            
            return timeA.compare(timeB) == .orderedDescending
        }).first { stop in
            // Make sure the arrival time is present
            guard let arrivalTime = stop.arrival?.actualTime else { return false }
            
            // Check whether the arrival time is in the future.
            // The next station is always the first one in the future.
            return arrivalTime > Date.now
        }
    }
    
    /// Either the current stop, or the next stop.
    var currentOrNextStop: Stop? {
        // If the current stop was found, return it
        if currentStop != nil {
            return currentStop
        } else {
            // Otherwise return the next stop
            return nextStop
        }
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
