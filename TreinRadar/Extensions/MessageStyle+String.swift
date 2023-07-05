//
//  MessageStyle+String.swift
//  TreinRadar
//
//  Created by Wisse Hes on 05/07/2023.
//

import Foundation

extension MessageStyle {
    var readable: String {
        switch self {
        case .info:
            "Info"
        case .warning:
            "Waarschuwing"
        }
    }
}
