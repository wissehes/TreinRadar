//
//  ContentView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PlannerView()
                .tabItem { Label("Planner", systemImage: "clock.badge.checkmark") }

            MapView()
                .tabItem { Label("Radar", systemImage: "map") }
            
            StationsSearchView()
                .tabItem { Label("Vertrektijden", systemImage: "clock.badge") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//#Preview {
//    ContentView()
//}
