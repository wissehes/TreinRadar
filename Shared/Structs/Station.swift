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
