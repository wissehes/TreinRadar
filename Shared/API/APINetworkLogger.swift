//
//  APINetworkLogger.swift
//  TreinRadar
//
//  Created by Wisse Hes on 02/09/2023.
//

import Foundation
import Alamofire

class APINetworkLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "nl.wissehes.treinradar.networklogger")
    
    func requestDidFinish(_ request: Request) {
      print(request.description)
    }
}
