//
//  MapView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import MapKit

fileprivate enum ChosenMapType: CaseIterable {
    case empty
    case stations
    case trains
    
    var localized: String {
        switch self {
        case .empty:
            return "Leeg"
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
    @State private var railwayTracks: [GeojsonGeometry] = []
    
    @State private var selectedTrain: Train?
    
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
                    TrainAnnotations(train: $selectedTrain)
                    
                default:
                    EmptyMapContent()
                }
                
                ForEach(railwayTracks, id: \.hashValue) { track in
                    MapPolyline(coordinates: track.actualCoordinates, contourStyle: .geodesic)
                        .foregroundStyle(.blue)
                        .stroke(lineWidth: 2)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .sheet(item: $selectedTrain, content: { item in
                NavigationStack {
                    JourneyView(journeyId: item.ritID)
                }
            })
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
            .task {
                await loadTrainTrackData()
            }
        }
    }
    
    func loadTrainTrackData() async {
        do {
            let data = try await API.shared.getMapGeoJson()
            let decoded = try JSONDecoder().decode(GeojsonPayload.self, from: data)
            
//            var lines: [JourneyFeature] = []
//            
//            for object in decoded {
//                if let feature = object as? MKGeoJSONFeature {
//                    for geometry in feature.geometry {
//                        if let line = geometry as? MKPolyline {
//                            lines.append(line)
//                        }
//                    }
//                }
//            }
//            
//            print("Decoded lines: \(lines.count)")
            
            self.railwayTracks = decoded.features.map { $0.geometry }
        } catch { print(error) }
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
