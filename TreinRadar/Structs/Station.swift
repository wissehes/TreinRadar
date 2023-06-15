//
//  Station.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation

protocol Station: Hashable {
    var code: String { get }
    var sporen: [Spoor] { get }
    var name: String { get }
}
