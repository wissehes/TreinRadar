//
//  LoadingView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 17/09/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            loadingAnimation
        } else {
            ProgressView("Laden...")
        }
    }
    
    @available(iOS 17.0, *)
    var loadingAnimation: some View {
        VStack(spacing: 10) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 72))
                .foregroundStyle(.cyan.gradient)
                .symbolEffect(.variableColor.iterative)
            
            Text("Laden...")
                .font(.title)
        }
    }
}

#Preview {
    LoadingView()
}
