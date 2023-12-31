//
//  StationAnnotations.swift
//  TreinRadar
//
//  Created by Wisse Hes on 27/07/2023.
//

import SwiftUI
import MapKit

extension StationType {
    var annotationColor: Color {
        switch self {
        case .megaStation:
            return .purple
        case .intercityStation, .knooppuntIntercityStation:
            return .cyan
        case .knooppuntStoptreinStation:
            return .indigo
        default:
            return .blue
        }
    }
}

@available(iOS 17.0, *)
struct StationAnnotations: MapContent {

    @EnvironmentObject var stationManager: StationsManager
        
    var body: some MapContent {
        ForEach(stationManager.stations?.filter { $0.land == .nl } ?? [], content: stationAnnotation)
    }
    
    func stationAnnotation(_ station: FullStation) -> some MapContent {
        Annotation(station.name, coordinate: station.coordinate, anchor: .center) {
            Circle()
                .fill(station.stationType.annotationColor)
                .overlay(Image(systemName: "tram.circle").foregroundStyle(.white))
                .frame(width: 25, height: 25, alignment: .center)
        }.tag(SelectedMapItem.station(station))
    }
}

//#Preview {
//    StationAnnotations()
//}
