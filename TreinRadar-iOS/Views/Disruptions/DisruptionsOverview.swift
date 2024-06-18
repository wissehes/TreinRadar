//
//  DisruptionsOverview.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 16/06/2024.
//

import SwiftUI

struct DisruptionsOverview: View {
    
    @State private var disruptions: [Disruption]?
    
    private func load() async {
        do {
            let data = try await API.shared.getAllDisruptions()
            self.disruptions = data
        } catch {
            debugPrint(error)
        }
    }
    
    var body: some View {
        List {
            if let disruptions {
                ForEach(disruptions) { item in
                    HStack {
                        Text(item.title)
                    }
                }
            } else {
                ProgressView()
            }
        }.navigationTitle("Storingen")
            .task { await load() }
    }
}

#Preview {
    NavigationStack {
        DisruptionsOverview()
    }
}
