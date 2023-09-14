//
//  NoteType+Localized.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 14/09/2023.
//

import Foundation

extension NoteType {
    var localized: String {
        switch self {
        case .unknown:
            "?"
        case .attribute:
            "Attribute"
        case .infotext:
            "Info"
        case .realtime:
            "Live"
        case .ticket:
            "Ticket"
        case .hint:
            "Hint"
        }
    }
}
