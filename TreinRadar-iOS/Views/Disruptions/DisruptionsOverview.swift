//
//  DisruptionsOverview.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 16/06/2024.
//

import SwiftUI

@resultBuilder
enum TextBuilder {
    static func buildBlock(_ components: [Text]) -> Text {
        components.reduce(Text(""), { item, secondItem in
            if item == Text("") {
                return item + secondItem
            } else {
                return item + Text(" - ") + secondItem
            }
        })
    }
}

struct DisruptionsOverview: View {
    
    @State private var disruptions: [Disruption]?
    
    private func load() async {
        do {
            let data = try await API.shared.getAllDisruptions()
            self.disruptions = data.filter({ $0.start ?? Date() <= Date() })
        } catch {
            debugPrint(error)
        }
    }
    
    var body: some View {
        List {
            if let disruptions {
                ForEach(disruptions) { item in
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading) {
                            ForEach(item.titleSections ?? [], id: \.self) { sections in
                                renderTitleSections(sections)
                                    .font(.headline)
                            }
                        }
                        
                        if let desc = item.summaryAdditionalTravelTime?.shortLabel {
                            Text(desc)
                        }
                        
                        if let end = item.end {
                            Text("t/m \(end, format: .dateTime.weekday(.wide).day().month(.wide).hour().minute())")
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }.navigationTitle("Storingen")
            .task { await load() }
    }
    
    @TextBuilder
    func renderTitleSections(_ sections: [Disruption.TitleSection]) -> Text {
        sections.map { section in
            switch section.type {
            case .icon:
                switch section.value {
                case "MAINTENANCE":
                    Text(Image(systemName: "exclamationmark.triangle"))
                        .bold()
                        .foregroundColor(.orange)
                default:
                    Text(Image(systemName: "exclamationmark.circle.fill"))
                        .bold()
                        .foregroundColor(.red)
                }
            case .station:
                Text(section.value)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DisruptionsOverview()
    }
}
