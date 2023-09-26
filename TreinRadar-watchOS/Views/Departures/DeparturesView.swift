//
//  DeparturesView.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 25/09/2023.
//

import SwiftUI

struct DeparturesView: View {
    
    var station: any Station
    
    @State private var departures: [Departure]?
    @State private var error: (any Error)?
    
    var body: some View {
        ZStack {
            if departures == nil {
                ProgressView()
            } else if let error = error {
                Text(error.localizedDescription)
                    .lineLimit(5)
            } else {
                departuresList
            }
        }.navigationTitle(station.name)
            .task { await self.load() }
    }
    
    var departuresList: some View {
        List(departures ?? [], id: \.name, rowContent: departureItem(departure:))
    }
    
    func departureItem(departure item: Departure) -> some View {
        NavigationLink {
            JourneyView(journeyId: item.product.number)
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(item.plannedDateTime, style: .time)
                        .bold()
                    
                    Text(item.product.longCategoryName)
                        .font(.callout)
                        .lineLimit(1)
                }
                
                Text(item.direction)
            }
        }
    }
    
    @MainActor
    func load() async {
        do {
            let departures = try await API.shared.getDepartures(stationCode: self.station.code)
            withAnimation { self.departures = departures }
        } catch {
            withAnimation { self.error = error }
            print(error)
        }
    }
}

#Preview {
    NavigationStack {
        DeparturesView(station: SavedStation(
            name: "Utrecht Centraal",
            code: "UT",
            land: .nl, lat: 0, lng: 0,
            sporen: [.init(spoorNummer: "21")]
        ))
    }
}
