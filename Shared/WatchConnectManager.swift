//
//  WatchConnectManager.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 23/09/2023.
//
/// Manager for the Watch Connectivity.

import Foundation
import WatchConnectivity
import Combine

final class WatchConnectManager: ObservableObject {
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<[SavedStation], Never>()
    let updateSubject = PassthroughSubject<String, Never>()
    let encoder = JSONEncoder()
    
    init(session: WCSession = .default) {
        self.session = session
        #if os(iOS)
        self.delegate = WCSessionDelegator(stationsSubject: subject, updateSubject: updateSubject)
        #elseif os(watchOS)
        self.delegate = WCSessionDelegator(stationsSubject: subject)
        #endif
        self.session.delegate = self.delegate
        self.session.activate()
    }
    
#if os(iOS)
    
    /// Send the updated stations to the watch
    func updateStations(_ stations: [SavedStation]) {
        // Make sure the session is reachable
        guard session.isReachable else { return }
        guard let encodedStations = try? encoder.encode(stations) else { return }
        
        // Send the favourite stations
        session.sendMessage(["favouriteStations": encodedStations], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
#endif
    
#if os(watchOS)
    
    /// Request an update of the favourite stations
    func requestUpdateStations() {
        guard session.isReachable else { return }
        
        session.sendMessage(["requestUpdate": "stations"], replyHandler: nil)
    }
    
#endif
    
}
