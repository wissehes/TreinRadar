//
//  WCSessionDelegator.swift
//  TreinRadar
//
//  Created by Wisse Hes on 22/09/2023.
//
/// Implements the `WatchConnectivity` session delegate for synchronizing
/// the favourite stations to the watchOS app

import Foundation
import WatchConnectivity
import Combine

final class WCSessionDelegator: NSObject, ObservableObject, WCSessionDelegate {
    
    let stationsSubject: PassthroughSubject<[SavedStation], Never>
    let decoder = JSONDecoder()
    
    init(stationsSubject: PassthroughSubject<[SavedStation], Never>) {
        self.stationsSubject = stationsSubject
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Needed for conformance only
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Make sure all data is present and decode it
        guard let favouriteStations = message["favouriteStations"] as? Data else { return }
        guard let decodedStations = try? decoder.decode([SavedStation].self, from: favouriteStations) else { return }
        
        DispatchQueue.main.async {
            self.stationsSubject.send(decodedStations)
        }
    }
    
#if os(iOS)
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
#endif
    
}
