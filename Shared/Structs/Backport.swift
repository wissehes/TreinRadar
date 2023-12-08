//
//  Backport.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 05/11/2023.
//
//  This file contains view modifiers only available for iOS 17 and up.

import Foundation
import SwiftUI

struct Backport<Content: View> {
    let content: Content
}

extension View {
    var backport: Backport<Self> { Backport(content: self) }
}

extension Backport {
//    @ViewBuilder func badge(_ count: Int) -> some View {
//        if #available(iOS 15, *) {
//            content.badge(count)
//        } else {
//            self.content
//        }
//    }
    
    @ViewBuilder func replaceSymbolEffect() -> some View {
        if #available(iOS 17, *) {
            content.contentTransition(.symbolEffect(.replace))
        } else {
            self.content
        }
    }
}
