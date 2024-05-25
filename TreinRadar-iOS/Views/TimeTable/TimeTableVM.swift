//
//  TimeTableVM.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 24/05/2024.
//

import Foundation
import SwiftUI

final class TimeTableViewModel: ObservableObject {
    
    var stationCode: String
    
    @Published var viewType: TimeTableType
    
    @Published var departures: [Departure]?
    @Published var arrivals: [Arrival]?
    
    @Published var chosenSpoor: ChosenSpoor = .all
    @Published var chosenMessageStyle: ChosenMessageStyle = .all
    @Published var showCancelledTrains: Bool = true
    
    @Published var isLoading = true
    
    private var formatter = RelativeDateTimeFormatter()
    
    init(stationCode: String, viewType: TimeTableType) {
        self.stationCode = stationCode
        self._viewType = .init(initialValue: viewType)
    }
    
    init(_ station: some Station, viewType: TimeTableType) {
        self.stationCode = station.code
        self._viewType = .init(initialValue: viewType)
    }
    
    private func setLoading(_ value: Bool) {
        DispatchQueue.main.async {
            withAnimation {
                self.isLoading = value
            }
        }
    }
    
    private func getDepartures() async {
        do {
            let data = try await API.shared.getDepartures(stationCode: stationCode)
            DispatchQueue.main.async {
                self.departures = data
            }
        } catch {
            //
        }
    }
    
    private func getArrivals() async {
        do {
            let data = try await API.shared.getArrivals(stationCode: stationCode)
            DispatchQueue.main.async {
                self.arrivals = data
            }
        } catch {
            //
        }
    }
    
    public func loadData() async {
        setLoading(true)
        defer {
            setLoading(false)
        }
        
        switch self.viewType {
        case .departures:
            await self.getDepartures()
        case .arrivals:
            await self.getArrivals()
        }
    }
}

extension TimeTableViewModel {
    enum TimeTableType {
        case departures
        case arrivals
    }
}
