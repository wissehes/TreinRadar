//
//  JourneyThisTrainView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 22/06/2024.
//

import SwiftUI

struct JourneyThisTrainView: View {
    
    var journey: JourneyPayload
    var nerdMode: Bool
    
    var body: some View {
        Section("Deze trein") {
            
            if journey.currentOrNextStop?.actualStock?.trainParts != nil {
                facilities
            }
            
            if let length = journey.currentOrNextStop?.actualStock?.numberOfParts {
                Text("Lengte: \(length) delen")
            }
            
            if nerdMode {
                if let stock = journey.currentOrNextStop?.actualStock?.trainType {
                    Text("Materieel: \(stock)")
                }
                
                if let seats = journey.currentOrNextStop?.actualStock?.numberOfSeats {
                    Text("Zitplaatsen: \(seats)")
                }
                
                Text("Ritnummer: **\(journey.productNumbers.joined(separator: ", "))**")
                
                if journey.stockNumbers != "0" {
                    Text("Materieel: \(journey.stockNumbers)")
                }
            }
            
            if let currentStop = journey.currentStop {
                Text("Huidig station: **\(currentStop.stop.name)**")
            } else if let nextStop = journey.nextStop {
                Text("Volgend station: **\(nextStop.stop.name)**")
            }
        }
    }
    
    var facilities: some View {
        let allFacilities: [Facility]? = journey.currentOrNextStop?.actualStock?.trainParts.flatMap({ part in
            part.facilities
        }).removingDuplicates()
        
        return ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 10) {
                ForEach(allFacilities ?? [], id: \.rawValue) { facility in
                    Image(systemName: facility.symbolName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }.frame(height: 40)
        }
    }
}

#Preview {
    NavigationStack {
        JourneyView(journeyId: "7383")
    }
}
