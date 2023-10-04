//
//  Stop+Computed.swift
//  TreinRadar
//
//  Created by Wisse Hes on 05/07/2023.
//

import Foundation

extension Stop {
    /// Arrival data
    var arrival: ArrivalOrDeparture? {
        self.arrivals.first
    }
    
    /// Departure data
    var departure: ArrivalOrDeparture? {
        self.departures.first
    }
    
    /// The track the train will enter/leave at/from
    var track: String? {
        return arrival?.actualTrack ?? departure?.actualTrack
    }
    
    /// Whether this stop should be displayed as skipped
    var shouldDisplayAsSkipped: Bool {
        let base = self.status == .passing || self.status == .unknown
        
        if base == true {
            return base
        } else if let arrival = self.arrival {
            // Returns `true` if the actual time is nil.
            return base || arrival.actualTime == nil
        } else if let departure = self.departure {
            // Returns `true` if the actual time is nil.
            return base || departure.actualTime == nil
        }
        
        return base
    }
    
    /// Formatted arrival time
    var arrivalTime: String? {
        if self.arrival?.actualTime == nil {
            return nil
        } else {
            return self.arrival?.plannedTime?.timeFormat()
        }
    }
    
    /// Amount of minutes the arrival is delayed by
    var arrivalDelay: Int {
        guard
            let planned = self.arrival?.plannedTime,
            let actual = self.arrival?.actualTime
        else { return 0 }
        
        return self.getDelay(plannedTime: planned, actualTime: actual)
    }
    
    /// Formatted departure time
    var departureTime: String? {
        if self.departure?.actualTime == nil {
            return nil
        } else {
            return self.departure?.plannedTime?.timeFormat()
        }
    }
    
    /// Amount of minutes the departure is delayed by
    var departureDelay: Int {
        guard
            let planned = self.departure?.plannedTime,
            let actual = self.departure?.actualTime
        else { return 0 }
        
        return self.getDelay(plannedTime: planned, actualTime: actual)
    }
    
    /**
     Returns the amount of minutes of the delay
     */
    private func getDelay(plannedTime: Date, actualTime: Date) -> Int {
        let diff = Int(actualTime.timeIntervalSince1970  - plannedTime.timeIntervalSince1970)
        let components = Calendar.current.dateComponents([.minute], from: plannedTime, to: actualTime)
        
        guard let minutes = components.minute, diff > 30 else { return 0 }
        return minutes
    }
    
    /// Crowd forecast
    var crowdForecast: CrowdForecast? {
        self.departure?.crowdForecast ?? self.arrival?.crowdForecast
    }
}
