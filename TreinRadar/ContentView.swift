//
//  ContentView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 3
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TravelInfoView()
                .tabItem { Label("Planner", systemImage: "clock.badge.checkmark") }
                .tag(1)
            
            if #available(iOS 17.0, *) {
                MapView()
                    .tabItem { Label("Radar", systemImage: "map") }
                    .tag(2)
            }
            
            StationsSearchView()
                .tabItem { Label("Vertrektijden", systemImage: "clock.badge") }
                .tag(3)
            
            SavedItemsView()
                .tabItem { Label("Opgeslagen", systemImage: "bookmark.fill") }
                .tag(4)
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
