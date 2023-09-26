//
//  Formatters.swift
//  TreinRadar
//
//  Created by Wisse Hes on 06/08/2023.
//

import Foundation

extension MeasurementFormatter {
    static var myFormatter: MeasurementFormatter {
        let formatter = self.init()
        formatter.unitOptions = [.providedUnit, .naturalScale]
        formatter.unitStyle = .long
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }
    
    /// Formatter for km/h formats
    static var kmhFormatter: MeasurementFormatter {
        let formatter = self.init()
        formatter.unitOptions = [.providedUnit]
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter
    }
}
