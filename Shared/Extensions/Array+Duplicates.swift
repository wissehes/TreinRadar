//
//  Array+Duplicates.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 04/10/2023.
//

import Foundation

extension Array where Element: Hashable {
    /**
     Removes duplicates from an array and returns it
     */
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    /**
     Removes duplicates from this array.
     */
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
