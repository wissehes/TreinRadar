//
//  CurrentTrainView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 06/07/2023.
//

import SwiftUI

struct CurrentTrainView: View {
    
    var journey: JourneyPayload
    var distance: Double?
    
    let timeFormatter = RelativeDateTimeFormatter()
    var measurementFormatter = MeasurementFormatter.myFormatter
    
    var nextStop: Stop? {
        let stops = journey.actualStops
        let nextStop = stops.first(where: {
            if let date = $0.arrival?.actualTime {
                return date > Date.now
            } else {
                return false
            }
        })
        return nextStop
    }
    
    var timeTillNextStop: String? {
        guard let nextArrival = nextStop?.arrival?.actualTime else { return nil }
        return timeFormatter.string(for: nextArrival)?.capitalizingFirstLetter()
    }
    
    var formattedDistance: String? {
        guard let distance = distance else { return nil }
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        return measurementFormatter.string(from: measurement)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("**\(journey.category)** naar \(journey.destination?.name ?? "?")")
                .font(.headline)
            if let distance = formattedDistance {
                Text("Afstand: \(distance)")
            }
            
            // Only show the next stop when available
            if let nextStop = nextStop {
                
                Divider()
                
                Text("Volgend station: **\(nextStop.stop.name)**")
                
                if let time = timeTillNextStop {
                    Text(time)
                }
            }
        }
    }
}

struct CurrentTrainView_Previews: PreviewProvider {
    static let data = try! MockData().getData(resource: "journey", type: JourneyPayload.self)
    
    static var previews: some View {
        List {
            CurrentTrainView(journey: data, distance: 1000)
        }
    }
}

