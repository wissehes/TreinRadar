//
//  StationsManager.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation

final class StationsManager: ObservableObject {
    
    static let shared = StationsManager()

    @Published var stations: [FullStation] = []
    
    init() {
        Task { await self.getData() }
    }
    
    func getData() async {
        do {
            let data = try await API.shared.getStations()
            DispatchQueue.main.async { self.stations = data }
        } catch { print(error) }
    }
    
    func getStation(code: String) -> FullStation? {
        self.stations.first { $0.code.lowercased() == code.lowercased() }
    }
}
