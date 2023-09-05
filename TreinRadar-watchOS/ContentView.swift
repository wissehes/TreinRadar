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
                NavigationLink("Nearby trains", destination: NearbyTrainsView())
                NavigationLink("Look up train", destination: LookupTrainView())
            }
        }
    }
}

#Preview {
    ContentView()
}
