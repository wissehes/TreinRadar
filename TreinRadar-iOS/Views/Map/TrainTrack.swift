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
    
    var railwayTracks: [MKPolyline]
    
    var body: some MapContent {
        ForEach(railwayTracks, id: \.hashValue) { track in
            MapPolyline(track)
                .stroke(.blue, lineWidth: 2)
        }
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
