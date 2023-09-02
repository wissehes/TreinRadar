//
//  MapView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import MapKit

fileprivate enum ChosenMapType: CaseIterable {
    case stations
    case trains
    
    var localized: String {
        switch self {
        case .stations:
            return "Stations"
        case .trains:
            return "Treinen"
        }
    }
}

@available(iOS 17.0, *)
struct MapView: View {
    
    @State private var selectedMap: ChosenMapType = .stations

    private var initialPosition: MapCameraPosition {
        return .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 52.1,
                    longitude: 4.9
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 2.5,
                    longitudeDelta: 2.5
                )
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            Map(initialPosition: initialPosition) {
                switch selectedMap {
                case .stations:
                    StationAnnotations()
                case .trains:
                    TrainAnnotations()
                }
            }
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FullStation.self, destination: { item in
                DeparturesView(station: item)
            })
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Picker("Kaarttype", selection: $selectedMap) {
                        ForEach(ChosenMapType.allCases, id: \.hashValue) { item in
                            Text(item.localized)
                                .tag(item)
                        }
                    }.pickerStyle(.segmented)
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            if #available(iOS 17.0, *) {
                MapView()
                    .environmentObject(StationsManager())
                    .environmentObject(TrainManager())
            } else {
                EmptyView()
            }
        }
    }
}

//#Preview {
//    MapView()
//}
