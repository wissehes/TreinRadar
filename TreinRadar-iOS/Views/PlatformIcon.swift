//
//  PlatformIcon.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 13/09/2023.
//

import SwiftUI

struct PlatformIcon: View {
    
    var platform: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.accentColor, lineWidth: 2.5)
            .overlay(
                Text(platform)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            )
            .frame(width: 35, height: 35, alignment: .center)
            .padding(2.5)
    }
}

#Preview {
    List {
        HStack {
            Text("Station XXX")
            Spacer()
            PlatformIcon(platform: "1a")
        }
    }
}
