//
//  LookupTrainView.swift
//  TreinRadar-watchOS
//
//  Created by Wisse Hes on 06/08/2023.
//

import SwiftUI
import SwiftUI_Apple_Watch_Decimal_Pad

struct LookupTrainView: View {
    @State private var train = ""
    @State private var isLoading = false
    
    var formatter: NumberFormatter {
        return NumberFormatter()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                DigiTextView(placeholder: "Treinstel", text: $train, presentingModal: false, alignment: .leading, style: .numbers)
                
                NavigationLink("Zoek op") {
                    JourneyView(stockNumber: train)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LookupTrainView()
    }
}
