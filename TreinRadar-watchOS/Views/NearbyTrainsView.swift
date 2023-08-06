//
//  NearbyTrainsView.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 06/08/2023.
//

import SwiftUI

struct NearbyTrainsView: View {
    @State private var isLoading = true
    
    var body: some View {
        if isLoading {
            ProgressView("Loading...")
        } else {
            List {
                Text("item")
            }
        }
    }
}

#Preview {
    NavigationStack {
        NearbyTrainsView()
    }
}
