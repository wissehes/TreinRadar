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
    
    @State var items: [FullStation]?
//    private var mapRegion = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(
//            latitude: 52.1,
//            longitude: 4.9
//        ),
//        span: MKCoordinateSpan(
//            latitudeDelta: 1.3,
//            longitudeDelta: 1.3
//        )
//    )
    
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
    
    func getData() async {
        do {
            let data = try await API.shared.getStations()
            DispatchQueue.main.async { self.items = data }
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        Map(initialPosition: initialPosition) {
            ForEach(items?.filter { $0.land == .nl } ?? []) { item in
                Annotation(item.name, coordinate: item.coordinate, anchor: .center) {
                    NavigationLink(value: item) {
                        Circle()
                            .fill(.blue)
                            .overlay(Image(systemName: "building.columns.circle").foregroundStyle(.white))
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
            }
        }
        .navigationDestination(for: FullStation.self, destination: { item in
            DeparturesView(station: item)
        })
        .task {
            await getData()
        }.refreshable {
            await getData()
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
