//
//  TravelInfoView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import SwiftUI

struct TravelInfoView: View {
    @StateObject var vm = TravelInfoViewModel()
        
    var body: some View {
        NavigationStack(path: $vm.presentedJourneys) {
            List {
                Section("Trein opzoeken") {
                    TextField("Treinstelnummer", text: $vm.stockNumber)
                        .disabled(vm.isLoading)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    
                    Button("Zoek op") {
                        Task { await vm.getJourneyId() }
                    }
                }
                
                Section("Treindetectie") {
                    
                }
            }.navigationDestination(for: JourneyId.self) { id in
                JourneyView(journeyId: id)
            }
        }
    }
}
struct TravelInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TravelInfoView()
    }
}
