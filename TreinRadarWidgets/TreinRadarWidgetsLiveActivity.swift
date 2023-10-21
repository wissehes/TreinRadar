//
//  TreinRadarWidgetsLiveActivity.swift
//  TreinRadarWidgets
//
//  Created by Wisse Hes on 21/10/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TreinRadarWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TreinRadarWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TreinRadarWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TreinRadarWidgetsAttributes {
    fileprivate static var preview: TreinRadarWidgetsAttributes {
        TreinRadarWidgetsAttributes(name: "World")
    }
}

extension TreinRadarWidgetsAttributes.ContentState {
    fileprivate static var smiley: TreinRadarWidgetsAttributes.ContentState {
        TreinRadarWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TreinRadarWidgetsAttributes.ContentState {
         TreinRadarWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .dynamicIsland(.expanded), using: TreinRadarWidgetsAttributes.preview) {
   TreinRadarWidgetsLiveActivity()
} contentStates: {
    TreinRadarWidgetsAttributes.ContentState.smiley
    TreinRadarWidgetsAttributes.ContentState.starEyes
}
