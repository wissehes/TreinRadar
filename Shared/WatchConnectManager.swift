//
//  WatchConnectManager.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 23/09/2023.
//

import Foundation
import WatchConnectivity
import Combine

final class WatchConnectManager: ObservableObject {
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<[SavedStation], Never>()
    let encoder = JSONEncoder()
    
    init(session: WCSession = .default) {
        self.session = session
        self.delegate = WCSessionDelegator(stationsSubject: subject)
        self.session.delegate = self.delegate
        self.session.activate()
    }
    
#if os(iOS)
    
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
}
