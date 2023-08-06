//
//  SavedStation.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation
import Defaults

struct SavedStation: Codable, Station, Defaults.Serializable {
    let name: String
    let code: String
    let land: Land
    let lat, lng: Double
    let sporen: [Spoor]
    
    init(name: String, code: String, land: Land, lat: Double, lng: Double, sporen: [Spoor]) {
        self.name = name
        self.code = code
        self.land = land
        self.lat = lat
        self.lng = lng
        self.sporen = sporen
    }
    
    init(_ station: FullStation) {
        self.name = station.namen.lang
        self.code = station.code
        self.land = station.land
        self.lat = station.lat
        self.lng = station.lng
        self.sporen = station.sporen
    }
}
