//
//  JourneyMapViewCoordinator.swift
//  TreinRadar
//
//  Created by Wisse Hes on 23/06/2023.
//

import Foundation
import UIKit
import MapKit

final class JourneyMapViewCoordinator: NSObject, MKMapViewDelegate {
    private let map: JourneyMapView
    private let stops: [StopInfo]
    
    init(map: JourneyMapView, stops: [StopInfo]) {
        self.map = map
        self.stops = stops
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        addStationMarkers(mapView)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotationView = views.first, let annotation = annotationView.annotation {
            if annotation is MKUserLocation {
                
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3.0
        return renderer
    }
    
    
    func addStationMarkers(_ mapView: MKMapView) {
        let annotations: [MKPointAnnotation] = self.stops.map { stop in
            let annotation = MKPointAnnotation()
            annotation.coordinate = stop.coordinates
            annotation.title = stop.name
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
}
