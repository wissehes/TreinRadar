//
//  TrainManager.swift
//  TreinRadar
//
//  Created by Wisse Hes on 24/06/2023.
//

import Foundation

final class TrainManager: ObservableObject {
    
    static let shared = TrainManager()

    @Published var trains: [Train] = []
    
    init() {
        Task { await self.getData() }
    }
    
    func getData() async {
        do {
            let data = try await API.shared.getLiveTrains()
            DispatchQueue.main.async { self.trains = data }
        } catch { print(error) }
    }
    
    func getTrain(_ journeyId: String) -> Train? {
        return trains.first { $0.ritID == journeyId }
    }
}
