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
    @Default(.favouriteStations) var favouriteStations
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    stations
                } header: {
                    Label("Favoriete stations", systemImage: "star")
                }
                
                Section {
                    journeys
                } header: {
                    Label("Opgeslagen reizen", systemImage: "bookmark")
                }
            }.navigationTitle("Opgeslagen items")
                .navigationDestination(for: SavedJourney.self) { item in JourneyView(journeyId: item.code) }
                .navigationDestination(for: SavedStation.self) { item in
                    StationView(station: item)
                }
                .animation(.easeInOut, value: favouriteStations)
                .animation(.easeInOut, value: savedJourneys)
        }
    }
    
    @ViewBuilder
    var stations: some View {
        if favouriteStations.count != 0 {
            ForEach(favouriteStations, id: \.code) { item in
                NavigationLink(item.name, value: item)
                    .swipeActions {
                        Button("Verwijder", systemImage: "star.slash", role: .destructive) {
                            favouriteStations.removeAll { $0.code == item.code }
                        }
                    }
            }
        } else {
            if #available(iOS 17.0, *) {
                ContentUnavailableView(
                    "Nog geen favoriete stations",
                    systemImage: "star",
                    description: Text("Voeg stations toe door op \(Image(systemName: "star")) te drukken.")
                )
            } else {
                Text("Nog geen favoriete stations")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    var journeys: some View {
        if savedJourneys.count != 0 {
            ForEach(savedJourneys) { item in
                NavigationLink(value: item) { journeyItem(item) }
            }
        } else {
            if #available(iOS 17.0, *) {
                ContentUnavailableView(
                    "Nog geen reizen opgeslagen",
                    systemImage: "bookmark",
                    description: Text("Voeg reizen toe door op \(Image(systemName: "star")) te drukken.")
                )
            } else {
                Text("Nog geen reizen opgeslagen")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    func journeyItem(_ item: SavedJourney) -> some View {
        VStack(alignment: .leading) {
            if let product = item.product {
                Text(verbatim: "\(product.operatorName) \(product.longCategoryName)")
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
        .environmentObject(StationsManager.shared)
}
