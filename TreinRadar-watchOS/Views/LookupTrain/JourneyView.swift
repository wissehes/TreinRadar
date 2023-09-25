//
//  JourneyView.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 13/08/2023.
//

import SwiftUI

enum JourneyIdentifier {
    case journeyId(String)
    case stockNumber(String)
    
    var id: String {
        switch self {
        case .journeyId(let string):
            return string
        case .stockNumber(let string):
            return string
        }
    }
}

struct JourneyView: View {
    
    var identifier: JourneyIdentifier
    
    init(stockNumber: String) {
        self.identifier = .stockNumber(stockNumber)
    }
    
    init(journeyId: String) {
        self.identifier = .journeyId(journeyId)
    }
    
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
        }.task { await vm.load(identifier: self.identifier) }
            .navigationTitle(vm.journey?.category ?? "Rit \(identifier.id)")
    }
    
    var arrowImg: Image {
        Image(systemName: "arrow.right")
    }
    
    func list(journey: JourneyPayload) -> some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 2.5) {
                    HStack(alignment: .center, spacing: 5) {
                        arrowImg
                        Text(journey.destination?.name ?? "?")
                    }.bold()
                    
                    if let length = vm.trainLength {
                        Text("\(length) delen")
                    }
                    
                    if let numberOfSeats = vm.numberOfSeats {
                        Text("\(numberOfSeats) zitplaatsen")
                    }
                }
            }
            
            Section("Stops") {
                
                if !vm.showingPreviousStops {
                    Button("Laat vorige zien") {
                        withAnimation { vm.showingPreviousStops.toggle() }
                    }.foregroundStyle(.blue)
                }
                
                ForEach(vm.stops, id: \.id) { item in
                    JourneyStopItem(item: item)
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
