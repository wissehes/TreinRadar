//
//  NearbyTrainItem.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 13/08/2023.
//

import SwiftUI

struct NearbyTrainItem: View {
    var train: NearbyTrain
    
    var name: String {
        let journeyOperator = train.journey.journeyOperator ?? ""
        
        if let category = train.journey.category {
            return "\(journeyOperator) \(category) \(train.journeyID)"
        } else {
            return String(localized: "Trein") + "?"
        }
    }
    
    var formatter = MeasurementFormatter.myFormatter
    
    var distance: String {
        let distance = Measurement(value: train.distance, unit: UnitLength.kilometers)
        return formatter.string(from: distance)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.subheadline)
                .lineLimit(1)
            
            HStack(alignment: .center, spacing: 2.5) {
                Image(systemName: "arrow.right")
                    .font(.subheadline)
                    .bold()
                Text(train.journey.destination ?? "unknown")
                    .lineLimit(1)
                    .bold()
            }
            
            Label(distance, systemImage: "point.topleft.down.curvedto.point.bottomright.up")
        }
    }
}

#Preview {
    List(try! MockData().getData(resource: "nearby-train", type: [NearbyTrain].self), id: \.journeyID) { item in
        NearbyTrainItem(train: item)
    }
}
