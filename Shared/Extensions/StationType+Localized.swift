//
//  StationType+Localized.swift
//  TreinRadar
//
//  Created by Wisse Hes on 03/10/2023.
//

import Foundation

extension StationType {
    var localized: String {
        switch self {
        case .facultatiefStation:
            return String(localized: "Facultatief Station")
        case .intercityStation:
            return String(localized: "Intercitystation")
        case .knooppuntIntercityStation:
            return String(localized: "Intercityknooppunt")
        case .knooppuntSneltreinStation:
            return String(localized: "Sneltreinenknooppunt")
        case .knooppuntStoptreinStation:
            return String(localized: "Stoptreinenknooppunt")
        case .megaStation:
            return String(localized: "Megastation")
        case .sneltreinStation:
            return String(localized: "Sneltreinstation")
        case .stoptreinStation:
            return String(localized: "Stoptreinstation")
        }
    }
}
