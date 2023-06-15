//
//  MapView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var items: [FullStation]?
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 52.1,
            longitude: 4.9
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 1.3,
            longitudeDelta: 1.3
        )
    )
    
    func getData() async {
        do {
            let data = try await API.shared.getStations()
            DispatchQueue.main.async { self.items = data }
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: items ?? []) { item in
//            MapMarker(
//                coordinate: item.coordinate,
//                tint: item.stationType == .megaStation ? .blue : .red
//            )
            
            MapAnnotation(coordinate: item.coordinate) {
                NavigationLink(value: item) {
                    Circle()
                        .fill(.blue)
                        .overlay(Image(systemName: "building.columns.circle").foregroundStyle(.white))
                        .frame(width: 25, height: 25, alignment: .center)
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
            MapView()
        }
    }
}

//#Preview {
//    MapView()
//}
