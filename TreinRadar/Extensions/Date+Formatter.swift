//
//  Date+Formatter.swift
//  TreinRadar
//
//  Created by Wisse Hes on 22/06/2023.
//

import Foundation

extension Date {
    func timeFormat() -> String {
        return self.formatted(date: .omitted, time: .shortened)
    }
    
    func relative() -> String {
        return self.formatted(.relative(presentation: .numeric))
    }
}
