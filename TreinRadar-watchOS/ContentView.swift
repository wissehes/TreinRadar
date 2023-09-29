//
//  ContentView.swift
//  TreinRadar-watchOS Watch App
//
//  Created by Wisse Hes on 06/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Vertrektijden", destination: StationsView())
                NavigationLink("Treinen dichtbij", destination: NearbyTrainsView())
                NavigationLink("Zoek treinstel op", destination: LookupTrainView())
            }.navigationTitle(Text(verbatim: "TreinRadar"))
        }
    }
}

#Preview {
    ContentView()
}
