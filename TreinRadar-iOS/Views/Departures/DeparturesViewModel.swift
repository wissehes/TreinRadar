//
//  DeparturesViewModel.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation

enum ChosenSpoor: Hashable {
    case all
    case specific(Spoor)
}

enum ChosenMessageStyle: Hashable {
    case all
    case specific(MessageStyle)
}

final class DeparturesViewModel: ObservableObject {
    
    @Published var departures: [Departure]?
    
    @Published var chosenSpoor: ChosenSpoor = .all
    @Published var chosenMessageStyle: ChosenMessageStyle = .all
    @Published var showCancelledTrains: Bool = true
    
    @Published var isLoading = true
    
    var relativeFormatter = RelativeDateTimeFormatter()
    
    func getData(_ station: String) async {
        do {
            let data = try await API.shared.getDepartures(stationCode: station)
            DispatchQueue.main.async { self.departures = data }
        } catch { print(error) }
    }
    
    func formatDepartureDate(_ dep: Departure) -> String {
        let date = dep.actualDateTime
        let diff = Int(date.timeIntervalSince1970 - Date.now.timeIntervalSince1970)
        
        if diff < 60 {
            return "over < 1 minuut"
        } else {
            return self.relativeFormatter.localizedString(for: dep.actualDateTime, relativeTo: .now)
        }
    }
}
