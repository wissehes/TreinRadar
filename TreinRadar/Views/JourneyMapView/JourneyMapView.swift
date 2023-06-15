//
//  JourneyMapView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 23/06/2023.
//

import SwiftUI
import MapKit

struct JourneyMapView: UIViewRepresentable {
    
    var geometry: StopsAndGeometry
    var inline: Bool
    
    private let mapZoomEdgeInsets = UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0)
    
    func makeCoordinator() -> JourneyMapViewCoordinator {
        JourneyMapViewCoordinator(map: self, stops: geometry.stops)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        mapView.isZoomEnabled = !inline
        mapView.isScrollEnabled = !inline
        mapView.isUserInteractionEnabled = !inline

        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<JourneyMapView>) {
        updateOverlays(from: uiView)
    }
    
    private func updateOverlays(from mapView: MKMapView) {
        mapView.removeOverlays(mapView.overlays)
        let polyline = MKPolyline(
            coordinates: geometry.actualCoordinates,
            count: geometry.actualCoordinates.count
        )
        mapView.addOverlay(polyline)
        setMapZoomArea(map: mapView, polyline: polyline, edgeInsets: mapZoomEdgeInsets, animated: true)
    }
    
    private func setMapZoomArea(map: MKMapView, polyline: MKPolyline, edgeInsets: UIEdgeInsets, animated: Bool = false) {
        map.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgeInsets, animated: animated)
    }
    
}

struct JourneyMapView_Previews: PreviewProvider {
    
    static let geometry: StopsAndGeometry = .init(
        id: "",
        stops: [],
        coordinates: []
    )
    
//    static let stops: [Stop] = []
    
    static var previews: some View {
        NavigationStack {
            JourneyMapView(geometry: geometry, inline: false)
        }
    }
}

