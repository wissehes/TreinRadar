//
//  JourneyView.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 13/08/2023.
//

import SwiftUI

struct JourneyView: View {
    
    var stockNumber: String
    
    @StateObject var vm = JourneyViewModel()
    
    var body: some View {
        ZStack {
            if vm.isLoading {
                ProgressView()
            } else if let journey = vm.journey {
                list(journey: journey)
            } else {
                Text(vm.error ?? "Unknown error occurred.")
            }
        }.task { await vm.load(stock: stockNumber) }
            .navigationTitle(vm.journey?.category ?? "Rit \(stockNumber)")
    }
    
    var arrowImg: Image {
        Image(systemName: "arrow.right")
    }
    
    func list(journey: JourneyPayload) -> some View {
        List {
            Section {
                HStack(alignment: .center, spacing: 5) {
                    arrowImg
                    Text(journey.destination?.name ?? "?")
                }
                
                if let length = vm.trainLength {
                    Text("\(length) delen")
                }
                
                if let numberOfSeats = vm.numberOfSeats {
                    Text("\(numberOfSeats) zitplaatsen")
                }
            }
            
            Section("Stops") {
                ForEach(vm.stops, id: \.id) { item in
                    Text(item.stop.name)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        JourneyView(stockNumber: "2348")
    }
}
