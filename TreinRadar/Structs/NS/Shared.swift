//
//  Shared.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import Foundation

// MARK: Product
struct Product: Codable, Hashable {
    let number: String
    let categoryCode: String
    let shortCategoryName, longCategoryName: String
    let operatorCode, operatorName: String
    let type: String
}
