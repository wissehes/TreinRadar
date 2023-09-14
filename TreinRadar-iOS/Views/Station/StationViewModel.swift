//
//  StationViewModel.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 13/09/2023.
//

import Foundation
import SwiftUI

final class StationViewModel: ObservableObject {
    
    @Published var departures: [Departure]?
//    @Published var arrivals:
    
    @Published var imageData: UIImage?
    
    func fetchDepartures(_ station: any Station) async {
        do {
            let departures = try await API.shared.getDepartures(stationCode: station.code)
            let slice = Array(departures.prefix(3))
            DispatchQueue.main.async {
                withAnimation { self.departures = slice }
            }
        } catch { print(error) }
    }
    
    @MainActor
    func fetchHeaderImage(_ station: FullStation) async {
        do {
            let data = try await API.shared.getStationHeaderImage(station)
            withAnimation {
                self.imageData = data
            }
        } catch { print(error) }
    }
}
