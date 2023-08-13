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
            if vm.loading != .done {
                ProgressView(vm.loading.localizedText)
            } else if let trains = vm.trains {
                List(trains) { train in
                    NearbyTrainItem(train: train)
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
