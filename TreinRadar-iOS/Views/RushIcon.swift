//
//  RushIcon.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 23/09/2023.
//

import SwiftUI

extension CrowdForecast {
    var iconName: String {
        switch self {
        case .low:
            return "rush-1"
        case .medium:
            return "rush-2"
        case .HIGH:
            return "rush-3"
        case .unknown:
            return "rush-0"
        }
    }
}

struct RushIcon: View {
    
    var crowd: CrowdForecast
    
    var body: some View {
        ZStack {
            Image(crowd.iconName)
                .resizable()
                .scaledToFit()
            
            Color(crowd.iconName).blendMode(.sourceAtop)
        }.drawingGroup(opaque: false)
            .frame(width: 35, height: 35, alignment: .center)
            .padding(2.5)
    }
}

#Preview {
    VStack {
        RushIcon(crowd: .unknown)
        RushIcon(crowd: .low)
        RushIcon(crowd: .medium)
        RushIcon(crowd: .HIGH)
    }
}
