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
    
    var station: (any Station)?
    
    @State private var disruptions: [Disruption]?
    
    private func load() async {
        do {
            let data = try await API.shared.getAllDisruptions(for: station ?? nil)
            self.disruptions = data.filter({ $0.start ?? Date() <= Date() })
        } catch {
            debugPrint(error)
        }
    }
    
    var body: some View {
        List {
            if let disruptions {
                ForEach(disruptions) { item in
                    switch item.type {
                    case .maintenance:
                        renderMaintenance(item)
                    default:
                        renderDisruption(item)
                    }
                }
            }
        }.navigationTitle("Storingen")
            .task { await load() }
            .animation(.easeInOut, value: disruptions)
            .overlay {
                if disruptions == nil {
                    ProgressView()
                }
            }
    }
    
    /// Render a disruption
    func renderDisruption(_ item: Disruption) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Consequence of the disruption
            if let consequence = item.publicationSections?.first?.consequence.description {
                Label(consequence.capitalizingFirstLetter(), systemImage: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .bold()
            }
            
            // Title sections
            if let titleSections = item.titleSections {
                VStack(alignment: .leading) {
                    ForEach(titleSections, id: \.self) { sections in
                        renderTitleSections(sections)
                            .font(.headline)
                    }
                }
            } else {
                // Otherwise just the disruption title
                Label(item.title, systemImage: "info.circle")
                    .font(.headline)
            }
            
            // Description and end date/time
            if item.summaryAdditionalTravelTime != nil || item.end != nil {
                VStack(alignment: .leading) {
                    if let desc = item.summaryAdditionalTravelTime?.shortLabel {
                        Text(desc)
                    }
                    
                    if let end = item.end {
                        Text("Dit duurt tot \(end, format: .dateTime.hour().minute())")
                    }
                }
            }
        }
    }
    
    
    /// Render a maintenance disruption
    func renderMaintenance(_ item: Disruption) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Maintenance title
            Label("Werkzaamheden", systemImage: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .bold()
            
            // Title sections
            if let titleSections = item.titleSections {
                VStack(alignment: .leading) {
                    ForEach(titleSections, id: \.self) { sections in
                        renderTitleSections(sections)
                            .font(.headline)
                    }
                }
            } else {
                // Otherwise just the disruption title
                Label(item.title, systemImage: "info.circle")
                    .font(.headline)
            }
            
            // Description and end date/time
            if item.summaryAdditionalTravelTime != nil || item.end != nil {
                VStack(alignment: .leading) {
                    // Consequence of the disruption
                    if let consequence = item.publicationSections?.first?.consequence.normalDescription {
                        Text(consequence)
                    }
                    
                    if let desc = item.summaryAdditionalTravelTime?.shortLabel {
                        Text(desc.capitalizingFirstLetter())
                    }
                    
                    if let end = item.end {
                        Text("t/m \(end, format: .dateTime.hour().minute().month().day())")
                    }
                }
            }
        }
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
