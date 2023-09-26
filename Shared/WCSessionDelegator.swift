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
    #if os(iOS)
    let updateSubject: PassthroughSubject<String, Never>
    #endif
    let decoder = JSONDecoder()
    
    #if os(iOS)
    // iOS Initializer
    init(stationsSubject: PassthroughSubject<[SavedStation], Never>, updateSubject: PassthroughSubject<String, Never>) {
        self.stationsSubject = stationsSubject
        self.updateSubject = updateSubject
        super.init()
    }
    
    #else
    // watchOS initializer
    init(stationsSubject: PassthroughSubject<[SavedStation], Never>) {
        self.stationsSubject = stationsSubject
        super.init()
    }
    
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Needed for conformance only
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Update stations
        if let stationsData = message["favouriteStations"] as? Data {
            sendStationsToSubject(data: stationsData)
        }
        
        #if os(iOS)
        // TODO: Use an enum for `requesteedEnum` instead of string.
        if let requestedUpdate = message["requestUpdate"] as? String, requestedUpdate == "stations", #available(iOS 16, *)  {
            DispatchQueue.main.async {
                self.updateSubject.send(requestedUpdate)
            }
        }
        #endif
        
    }
    
    /// Send the favourited stations from the message to the subject
    func sendStationsToSubject(data: Data) {
        // Make sure all data is present and decode it
        guard let decodedStations = try? decoder.decode([SavedStation].self, from: data) else { return }
        
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
