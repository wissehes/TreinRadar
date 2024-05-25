//
//  TimeTableItem.swift
//  TreinRadar
//
//  Created by Wisse Hes on 25/05/2024.
//

import Foundation

/// Time Table Item containing arrival or departure information
///
/// This item contains information about a single time table item, this could
/// be a departure or an arrival.
protocol TimeTableItem {
    var type: TimeTableType { get }

    /// Planned arrival or departure track
    var plannedTrack: String? { get }
    /// Actual arrival or departure track
    var actualTrack: String? { get }
    
    /// The originating station name of this item
    var origin: String? { get }
    /// The direction of this item
    var direction: String? { get }
    
    /// The planned time of departure or arrival
    var plannedDateTime: Date { get }
    /// The actual time of departure or arrival
    var actualDateTime: Date { get }
    
    var product: Product { get }
    
    var messages: [Message] { get }
    
    var cancelled: Bool { get }
    
    var status: TimeTableStatus { get }
}

/// The type of time table item
enum TimeTableType: Codable {
    /// A departure
    case departure
    /// An arrival
    case arrival
}

enum TimeTableStatus: String, Codable {
    case onStation = "ON_STATION"
    case incoming = "INCOMING"
    case departed = "DEPARTED"
    case unknown = "UNKNOWN"
}
