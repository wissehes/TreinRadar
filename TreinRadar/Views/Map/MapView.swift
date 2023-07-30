//
//  MapView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct MapView: View {
    
//    @State var items: [FullStation]?

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
                StationAnnotations()
            }
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FullStation.self, destination: { item in
                DeparturesView(station: item)
            })
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            if #available(iOS 17.0, *) {
                MapView()
            } else {
                EmptyView()
            }
        }
    }
}

//#Preview {
//    MapView()
//}
