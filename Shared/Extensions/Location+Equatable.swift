//
//  Location+Equatable.swift
//  TreinRadar
//
//  Created by Wisse Hes on 25/06/2023.
//

import Foundation
import CoreLocation


extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
