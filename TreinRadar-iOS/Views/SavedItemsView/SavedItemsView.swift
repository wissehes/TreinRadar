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
            if let product = item.product {
                Text("\(product.operatorName) \(product.longCategoryName)")
                    .bold()
            }
            HStack(alignment: .center) {
                Text(item.start.name)
                Label("Naar", systemImage: "arrow.right")
                    .labelStyle(.iconOnly)
                Text(item.end.name)
            }.lineLimit(1)
            
            Text("\(item.saved.relative()) opgeslagen")
                .font(.subheadline)
        }.swipeActions {
            Button(role: .destructive) {
                savedJourneys.removeAll { $0.id == item.id }
            } label: {
                Label("Uit opgeslagen verwijderen", systemImage: "bookmark.slash")
            }
        }
    }
}

#Preview {
    SavedItemsView()
}
