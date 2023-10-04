//
//  Facility+Symbol.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 04/10/2023.
//

import Foundation

extension Facility {
    var symbolName: String {
        switch self {
        case .fiets:
            return "bicycle"
        case .stilte:
            return "speaker.slash"
        case .stroom:
            return "powerplug"
        case .toegankelijk:
            return "figure.roll"
        case .toilet:
            return "toilet"
        case .wifi:
            return "wifi"
        }
    }
}
