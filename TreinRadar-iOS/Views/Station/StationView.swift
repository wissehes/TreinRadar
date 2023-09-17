//
//  StationView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 12/09/2023.
//

import SwiftUI

/**
 Station overview
 - Station details (tracks, station type, etc)
 - Most recent departures
 - Most recent arrivals
 */
struct StationView: View {
    
    var station: any Station
    @StateObject var vm: StationViewModel
    
    init(station: any Station) {
        self.station = station
        _vm = StateObject(wrappedValue: .init())
    }
    
    init(station: FullStation) {
        self.station = station
        _vm = StateObject(wrappedValue: .init(station: station))
    }
    
    var body: some View {
        ZStack {
            
            if let station = vm.station {
                listView(station)
            } else {
                ProgressView()
            }
            
        }
        .navigationDestination(for: FullStation.self, destination: { station in
            DeparturesView(station: station)
        })
        .navigationDestination(for: Departure.self, destination: { departure in
            JourneyView(journeyId: departure.product.number)
        })
        .headerProminence(.increased)
        .task {
            await vm.initialise(station: self.station)
        }
        
    }
    
    func listView(_ station: FullStation) -> some View {
        List {
            Section("Info") {
                if let image = vm.imageData {
                    StationHeaderImage(image: image)
                }
                
                HStack {
                    Text(station.stationType.rawValue)
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(station.sporen, id:\.spoorNummer) { item in
                            PlatformIcon(platform: item.spoorNummer)
                        }
                    }.padding(.bottom, 5)
                }
            }
            
            Section("Vertrektijden") {
                if let departures = vm.departures {
                    ForEach(departures, id: \.name, content: departureItem(item:))
                    
                    NavigationLink("Meer", value: station)
                        .foregroundStyle(Color.accentColor)
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            
            Section("Aankomsttijden") {
                Text("vertrek 1")
                Text("vertrek 2")
            }
        }.navigationTitle(station.namen.lang)
    }
    
    func departureItem(item: Departure) -> some View {
        NavigationLink(value: item) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        
                        Text(item.actualDateTime, style: .time)
                            .bold()
                        
                        Text(item.product.longCategoryName)
                            .font(.subheadline)
                        
                    }
                    
                    Text(item.direction)
                }
                
                if let platform = item.actualTrack {
                    Spacer()
                    PlatformIcon(platform: platform)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StationView(station: try! MockData().getData(resource: "station", type: FullStation.self))
    }
}
