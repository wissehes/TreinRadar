//
//  StationAnnotation.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import UIKit
import MapKit

class StationAnnotation: NSObject, MKAnnotation {
    init(title: String?, stationType: StationType, coordinate: CLLocationCoordinate2D, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
        
        self.stationType = stationType
        self.coordinate = coordinate
    }
    
    let title: String?
    let subtitle: String?
    
    let stationType: StationType
    let coordinate: CLLocationCoordinate2D
}
