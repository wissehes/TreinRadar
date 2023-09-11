//
//  ContentView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 15/06/2023.
//

import SwiftUI

fileprivate enum SelectedTab {
    case travelInfo
    @available(iOS 17.0 , *)
    case mapView
    case stations
    case saved
}

struct ContentView: View {
    
    @State private var selectedTab: SelectedTab = .travelInfo
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TravelInfoView()
                .tabItem { Label("Planner", systemImage: "clock.badge.checkmark") }
                .tag(SelectedTab.travelInfo)
            
            if #available(iOS 17.0, *) {
                MapView()
                    .tabItem { Label("Radar", systemImage: "map") }
                    .tag(SelectedTab.mapView)
            }
            
            StationsSearchView()
                .tabItem { Label("Vertrektijden", systemImage: "clock.badge") }
                .tag(SelectedTab.stations)
            
            SavedItemsView()
                .tabItem { Label("Opgeslagen", systemImage: "bookmark.fill") }
                .tag(SelectedTab.saved)
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
