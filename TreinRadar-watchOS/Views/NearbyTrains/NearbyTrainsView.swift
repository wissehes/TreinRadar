//
//  NearbyTrainsView.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 06/08/2023.
//

import SwiftUI

struct NearbyTrainsView: View {
    @StateObject var vm = NearbyTrainsViewModel()
    
    var body: some View {
        ZStack {
            if vm.isLoading {
                ProgressView("Loading...")
            } else if let trains = vm.trains {
                List(trains) { train in
                    VStack(alignment: .leading) {
                        Text(train.journey.category ?? "trein")
                            .font(.subheadline)
                        Text(train.journey.destination ?? "unknown")
                    }
                }
            } else {
                Text(vm.error ?? "Something went wrong.")
                    .padding()
            }
        }
        .task {
            await vm.getNearbyTrains()
        }
    }
}

#Preview {
    NavigationStack {
        NearbyTrainsView()
    }
}
