//
//  JourneyLiveActivity.swift
//  TreinRadarWidgetsExtension
//
//  Created by Wisse Hes on 21/10/2023.
//

import Foundation
import ActivityKit
import WidgetKit
import SwiftUI

struct JourneyLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for:  JourneyAttributes.self) { context in
            VStack {
                Text("Huidig/volgend station: \(context.state.journey.currentOrNextStop?.stop.name ?? "?")")
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    //                Text(context.state.journey)
                    Text("Hello!")
                    // more content
                }
            }compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("M")
            }.keylineTint(Color.red)
        }
    }
}
