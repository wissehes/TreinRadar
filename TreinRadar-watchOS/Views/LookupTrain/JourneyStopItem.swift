//
//  JourneyStopItem.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 13/08/2023.
//

import SwiftUI

struct JourneyStopItem: View {
    var item: Stop
    
    var arrivalIsDelayed: Bool {
        let plannedTime = item.arrival?.plannedTime
        let actualTime = item.arrival?.actualTime
        
        if let plannedTime = plannedTime, let actualTime = actualTime {
            return actualTime > plannedTime
        } else {
            return false
        }
    }
    
    var departureIsDelayed: Bool {
        let plannedTime = item.departure?.plannedTime
        let actualTime = item.departure?.actualTime
        
        if let plannedTime = plannedTime, let actualTime = actualTime {
            return actualTime > plannedTime
        } else {
            return false
        }
    }
    
    var times: some View {
        HStack(alignment: .center, spacing: 2.5) {
            if let arrival = item.arrivalTime {
                Text(arrival)
                    .foregroundStyle(arrivalIsDelayed ? .red : .white)
                
                Image(systemName: "arrow.right")
            }
            
            
            if let departure = item.departureTime {
                Text(departure)
                    .foregroundStyle(departureIsDelayed ? .red : .white)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            times
            
            Text(item.stop.name)
                .bold()
        }
    }
}

#Preview {
    List(try! MockData().getData(resource: "journey", type: JourneyPayload.self).stops.filter({ $0.status != .passing }), id: \.id) { stop in
        JourneyStopItem(item: stop)
    }
}
