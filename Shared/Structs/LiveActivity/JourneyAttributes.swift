//
//  JourneyAttributes.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 21/10/2023.
//

import Foundation
import ActivityKit

struct JourneyAttributes: ActivityAttributes {
    struct ContentState: Codable & Hashable {
        let journey: JourneyPayload
    }
}
