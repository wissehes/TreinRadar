//
//  FavouriteStationTip.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 03/10/2023.
//

import Foundation
import SwiftUI
import TipKit

@available(iOS 17.0, *)
struct FavouriteStationTip: Tip {
    var title: Text {
        Text("Voeg toe aan favorieten")
    }
    
    var message: Text? {
        Text("Je favoriete stations staan altijd bovenaan de lijst. Zo kun je ze makkelijk bekijken.")
    }
    
    var image: Image? {
        Image(systemName: "star")
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        VStack {
            TipView(FavouriteStationTip())
                .padding()
        }
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate),
            ])
        }
    } else {
        EmptyView()
    }
}
