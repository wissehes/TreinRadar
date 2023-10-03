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
            
            if let trains = vm.trains {
                List(trains) { train in
                    NavigationLink {
                        JourneyView(journeyId: train.journeyID)
                    } label: {
                        NearbyTrainItem(train: train)
                    }
                }
            } else if vm.loading != .done {
                ProgressView(vm.loading.localizedText)
            } else {
                Text(vm.error ?? String(localized: "Something went wrong."))
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
