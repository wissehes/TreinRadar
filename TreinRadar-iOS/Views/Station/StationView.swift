//
//  StationView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 12/09/2023.
//

import SwiftUI
import Defaults

/**
 Station overview
 - Station details (tracks, station type, etc)
 - TODO: Calamity's/disruptions list
 - Most recent departures
 - Most recent arrivals
 */
struct StationView: View {
    
    var station: any Station
    @StateObject var vm: StationViewModel
    @Default(.favouriteStations) var favouriteStations
    
    init(station: any Station) {
        self.station = station
        _vm = StateObject(wrappedValue: .init())
    }
    
    init(station: SelectedStation) {
        switch station {
        case .favourite(let savedStation):
            self.station = savedStation
            _vm = StateObject(wrappedValue: .init())
            break;
            
        case .full(let fullStation):
            self.station = fullStation
            _vm = StateObject(wrappedValue: .init(station: fullStation))
            break;
            
        case .nearby(let fullStation):
            self.station = fullStation
            _vm = StateObject(wrappedValue: .init(station: fullStation))
            break;
        }
    }
    
    init(station: FullStation) {
        self.station = station
        _vm = StateObject(wrappedValue: .init(station: station))
    }
    
    var isSaved: Bool { favouriteStations.contains(where: { $0.code == self.station.code }) }
    
    var body: some View {
        ZStack {
            
            if vm.isLoading {
                LoadingView()
            } else if let station = vm.station {
                listView(station)
            } else {
                if #available(iOS 17.0, *) {
                    ContentUnavailableView("Er ging iets mis...", systemImage: "wifi.exclamationmark")
                } else {
                    Text("Er ging iets mis...")
                }
            }
            
        }
        .animation(.easeInOut, value: vm.isLoading)
        .navigationTitle(station.name)
        .navigationDestination(for: Departure.self) { departure in
            JourneyView(journeyId: departure.product.number)
        }
        .navigationDestination(for: Arrival.self) { arrival in
            JourneyView(journeyId: arrival.product.number)
        }
        .navigationDestination(for: StationViewType.self) { type in
            switch type {
            case .arrivals(_):
                if #available(iOS 17.0, *) {
                    ContentUnavailableView("Aankomsttijden zijn nog niet beschikbaar", systemImage: "exclamationmark.bubble")
                } else {
                    Text("Aankomsttijden zijn nog niet beschikbaar")
                }
            case .departures(let station):
                DeparturesView(station: station)
            }
        }
        .headerProminence(.increased)
        .task(id: station.code) {
            await vm.initialise(station: self.station)
        }
        
    }
    
    func listView(_ station: FullStation) -> some View {
        List {
            Section {
                if let image = vm.imageData {
                    StationHeaderImage(image: image)
                }
                
                HStack {
                    Text(station.stationType.localized)
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
                    
                    NavigationLink("Meer", value: StationViewType.departures(station))
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
                if let arrivals = vm.arrivals {
                    ForEach(arrivals, id: \.name, content: arrivalItem(item:))
                    
                    NavigationLink("Meer", value: StationViewType.arrivals(station))
                        .foregroundStyle(Color.accentColor)
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isSaved ? "Verwijder uit favorieten" : "Voeg toe aan favorieten", systemImage: isSaved ? "star.fill" : "star") {
                    if isSaved {
                        favouriteStations.removeAll { $0.code == station.code }
                    } else {
                        favouriteStations.append(.init(station))
                    }
                }
                .backport.replaceSymbolEffect()
                .labelStyle(.iconOnly)
            }
        }
    }
    
    func departureItem(item: Departure) -> some View {
        NavigationLink(value: item) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        
                        Text(item.actualDateTime.timeFormat())
                            .bold()
                        
                        Text(item.product.longCategoryName)
                            .font(.callout)
                        
                    }
                    
                    Text(item.direction)
                }
                
                if let platform = item.actualTrack {
                    Spacer()
                    PlatformIcon(platform: platform, changed: item.plannedTrack != item.actualTrack)
                }
            }
        }
    }
    
    func arrivalItem(item: Arrival) -> some View {
        NavigationLink(value: item) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        
                        Text(item.actualDateTime.timeFormat())
                            .bold()
                        
                        Text(item.product.longCategoryName)
                            .font(.callout)
                        
                    }
                    
                    Text(item.origin)
                }
                
                if let platform = item.actualTrack {
                    Spacer()
                    PlatformIcon(platform: platform, changed: item.plannedTrack != item.actualTrack)
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

#Preview {
    StationsSearchView()
        .environmentObject(StationsManager.shared)
        .environmentObject(LocationManager.shared)
}
