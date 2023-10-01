//
//  MapView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI
import MapKit
import Defaults

fileprivate let initialPosition = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
        latitude: 52.1,
        longitude: 4.9
    ),
    span: MKCoordinateSpan(
        latitudeDelta: 2.5,
        longitudeDelta: 2.5
    )
)

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

enum SelectedMapItem: Identifiable, Equatable {
    static func == (lhs: SelectedMapItem, rhs: SelectedMapItem) -> Bool {
        lhs.id == rhs.id
    }
    
    case station(FullStation)
    case train(Train)
    
    var id: String {
        switch self {
        case .station(let fullStation):
            fullStation.id
        case .train(let train):
            train.ritID
        }
    }
}

@available(iOS 17.0, *)
struct MapView: View {
    
    @State private var selectedMap: ChosenMapType = .empty
    @State private var railwayTracks: [MKPolyline] = []
    
    @State private var selectedItem: SelectedMapItem?
    
    @State private var position: MapCameraPosition = .region(initialPosition)
    
    @EnvironmentObject var trainManager: TrainManager
    
    var body: some View {
        NavigationStack {
            Map(position: $position) {
                
                switch selectedMap {
                case .stations:
                    StationAnnotations(item: $selectedItem)
                case .trains:
                    TrainAnnotations(item: $selectedItem)
                    
                default:
                    EmptyMapContent()
                }
                
                // Railway polylines
                ForEach(railwayTracks, id: \.hashValue) { track in
                    MapPolyline(track)
                        .stroke(.blue, lineWidth: 2)
                }
                
            }
            .mapStyle(.standard(pointsOfInterest: [.publicTransport, .airport]))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .sheet(item: $selectedItem) { item in
                sheetContent(selectedItem: item)
                    .presentationDetents([.fraction(0.3), .medium, .large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.3)))
            }
            .navigationTitle("Radar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Picker("Kaarttype", selection: $selectedMap) {
                        ForEach(ChosenMapType.allCases, id: \.hashValue) { item in
                            Text(item.localized)
                                .tag(item)
                        }
                    }.pickerStyle(.segmented)
                }
                
                if selectedMap == .trains {
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            Task { await trainManager.getData() }
                        } label: {
                            Label("Ververs", systemImage: "arrow.clockwise")
                                .labelStyle(.iconOnly)
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        trainsMenu
                    }
                }
            }
            .task {
                await loadTrainTrackData()
            }
            .onAppear {
                trainManager.restartTimer()
            }
            .onDisappear {
                trainManager.stopTimer()
            }
            .onReceive(trainManager.updateTrains) { _ in
                guard Defaults[.trainsShouldRefetch] == true else { return }
                guard case .trains = selectedMap else { return }
                guard selectedItem == nil else { return }
                
                Task { await trainManager.getData() }
            }
        }
    }
    
    func sheetContent(selectedItem: SelectedMapItem) -> some View {
        NavigationStack {
            Group {
                switch selectedItem {
                case .train(let train):
                    JourneyView(journeyId: train.ritID)
                case .station(let station):
                    StationView(station: station)
                }
            }.navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Sluiten") { self.selectedItem = nil }
                    }
                }
        }
    }
    
    func loadTrainTrackData() async {
        do {
            let data = try await API.shared.getMapGeoJson()
            
            let decoded = try MKGeoJSONDecoder().decode(data)
            
            var lines: [MKPolyline] = []
            
            for object in decoded {
                if let feature = object as? MKGeoJSONFeature {
                    for geometry in feature.geometry {
                        if let line = geometry as? MKPolyline {
                            lines.append(line)
                        }
                    }
                }
            }
            
            self.railwayTracks = lines
        } catch { print(error) }
    }
    
    var trainsMenu: some View {
        Menu {
            Defaults.Toggle(key: .trainsShouldRefetch) {
                Label("Automatisch verversen", systemImage: "clock.arrow.circlepath")
            }
        } label: {
            Label("Menu", systemImage: "ellipsis")
                .labelStyle(.iconOnly)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            if #available(iOS 17.0, *) {
                MapView()
                    .environmentObject(StationsManager.shared)
                    .environmentObject(TrainManager.shared)
                    .task { await StationsManager.shared.getData() }
                    .task { await TrainManager.shared.getData() }
            } else {
                EmptyView()
            }
        }
    }
}

//#Preview {
//    MapView()
//}
