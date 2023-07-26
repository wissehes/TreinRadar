//
//  String+Capitalization.swift
//  TreinRadar
//
//  Created by Wisse Hes on 06/07/2023.
//

import Foundation

extension String {
    /**
     Captializes the first letter of this string and returns it.
     */
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
