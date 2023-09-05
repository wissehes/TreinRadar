//
//  TrainTrack.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 02/09/2023.
//

import SwiftUI
import MapKit

/**
 Renders the train tracks on the map
 */
@available(iOS 17.0, *)
struct TrainTrack: MapContent {
    
    var trackLines: [MKPolyline]
    
    var body: some MapContent {
        ForEach(trackLines, id: \.title) { polyline in
            MapPolyline(polyline)
                .foregroundStyle(.blue)
                .stroke(lineWidth: 2)
        }
        
//        MapPolyline
    }
}

//#Preview {
//    if #available(iOS 17.0, *) {
//        Map {
//            TrainTrack()
//        }
//    } else {
//        EmptyView()
//    }
//}
