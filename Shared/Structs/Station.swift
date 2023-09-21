//
//  Station.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation

protocol Station: Hashable {
    var code: String { get }
    var sporen: [Spoor] { get }
    var name: String { get }
}

extension Station {
    /**
     URL to header image
     */
    var imageUrl: URL? {
        URL(string: "https://assets.travelsupport-p.cla.ns.nl/stations/hero-images/\(self.code.lowercased())_small.jpg")
    }
}

/**
 What kind of station view to show
 */
enum StationViewType: Hashable {
    static func == (lhs: StationViewType, rhs: StationViewType) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    case departures(any Station)
    case arrivals(any Station)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .departures(let station):
            hasher.combine(station)
        case .arrivals(let station):
            hasher.combine(station)
        }
    }
}
