//
//  StationsManager.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation
import CoreLocation

enum StationCode {
    case code(String)
    case uicCode(String)
}

final class StationsManager: ObservableObject {
    
    static let shared = StationsManager()

    @Published var stations: [FullStation]?
    @Published var nearbyStations: [StationWithDistance]?
    
    func getData() async {
        /// Make sure there are no stations yet. We don't want to re fetch the stations
        /// when it's not really needed, since this list doesn't change.
        guard self.stations == nil else { return }
        
        do {
            let data = try await API.shared.getStations()
            DispatchQueue.main.async { self.stations = data }
        } catch { print(error) }
    }
    
    func getStation(code: StationCode) -> FullStation? {
        switch code {
        case .code(let code):
            return self.stations?.first { $0.code.lowercased() == code.lowercased() }
        case .uicCode(let code):
            return self.stations?.first { $0.uicCode.lowercased() == code.lowercased() }
        }
    }
    
    private func getStations() async -> [FullStation]? {
        if let stations = self.stations, !stations.isEmpty {
            return stations
        }
        await self.getData()
        return self.stations
    }
    
    func getNearbyStations(location: CLLocation) async {
        guard let stations = await self.getStations() else { return }
        
        let mapped: [StationWithDistance] = stations.map { station in
            let stationLocation = CLLocation(latitude: station.lat, longitude: station.lng)
            let distance = location.distance(from: stationLocation)
            
            return .init(station, location: stationLocation, distance: distance)
        }
        
        let sorted = mapped.sorted { $0.distance < $1.distance }
        
        DispatchQueue.main.async {
            self.nearbyStations = Array(sorted.prefix(5))
        }
    }
}
