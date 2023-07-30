//
//  StationAnnotations.swift
//  TreinRadar
//
//  Created by Wisse Hes on 27/07/2023.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct StationAnnotations: MapContent {
//    typealias Body = Self.Body÷
    
    @EnvironmentObject var stationManager: StationsManager
    
    var body: some MapContent {
        ForEach(stationManager.stations?.filter { $0.land == .nl } ?? [], content: stationAnnotation)
    }
    
    func stationAnnotation(_ station: FullStation) -> some MapContent {
        Annotation(station.name, coordinate: station.coordinate, anchor: .center) {
            NavigationLink(value: station) {
                Circle()
                    .fill(station.stationType == .megaStation ? .purple : .blue)
                    .overlay(Image(systemName: "building.columns.circle").foregroundStyle(.white))
                    .frame(width: 25, height: 25, alignment: .center)
            }
        }
    }
}

//#Preview {
//    StationAnnotations()
//}
