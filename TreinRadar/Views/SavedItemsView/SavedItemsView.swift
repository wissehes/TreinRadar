//
//  SavedItemsView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 30/07/2023.
//

import SwiftUI
import Defaults

struct SavedItemsView: View {
    @Default(.savedJourneys) var savedJourneys
    
    var body: some View {
        NavigationStack {
            List {
                Section("Reizen") {
                    ForEach(savedJourneys) { item in
                        NavigationLink(value: item) { journeyItem(item) }
                    }
                }
            }.navigationTitle("Opgeslagen items")
                .navigationDestination(for: SavedJourney.self, destination: { item in JourneyView(journeyId: item.code) })
        }
    }
    
    func journeyItem(_ item: SavedJourney) -> some View {
        VStack(alignment: .leading) {
            Text(item.start.name)
            Text(item.end.name)
        }
    }
}

#Preview {
    SavedItemsView()
}
