//
//  StationViewModel.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 13/09/2023.
//

import Foundation
import SwiftUI

final class StationViewModel: ObservableObject {
    
    @Published var station: FullStation?
    @Published var isLoading = true
    
    @Published var departures: [Departure]?
    @Published var arrivals: [Arrival]?
    
    @Published var imageData: UIImage?
    
    /**
     If the StationView got a FullStation, set it as the value
     */
    init(station: FullStation? = nil) {
        self.station = station
    }
    
    @MainActor
    func initialise(station: any Station) async {
        // If the new station is not equal to the current station
        // show the loading overlay
        if station.code != self.station?.code {
            isLoading = true
        }
        
        defer {
            isLoading = false
        }
        
        await StationsManager.shared.getData()
        
        
        guard let foundStation = StationsManager.shared.getStation(code: .code(station.code)) else { return }
        withAnimation {
            self.station = foundStation
        }
        
        await self.fetchHeaderImage(station)        
        await self.fetchDepartures(station)
        await self.fetchArrivals(station)
    }
    
    @MainActor
    private func fetchDepartures(_ station: any Station) async {
        do {
            let departures = try await API.shared.getDepartures(stationCode: station.code)
            let slice = Array(departures.prefix(3))
            
            withAnimation { self.departures = slice }
        } catch { print(error) }
    }
    
    @MainActor
    private func fetchArrivals(_ station: any Station) async {
        do {
            let arrivals = try await API.shared.getArrivals(stationCode: station.code)
            let slice = Array(arrivals.prefix(3))
            
            withAnimation { self.arrivals = slice }
        } catch { print(error) }
    }
    
    @MainActor
    private func fetchHeaderImage(_ station: any Station) async {
        do {
            let data = try await API.shared.getStationHeaderImage(station)
            withAnimation {
                self.imageData = data
            }
        } catch {
            self.imageData = nil
            print(error)
        }
    }
}
