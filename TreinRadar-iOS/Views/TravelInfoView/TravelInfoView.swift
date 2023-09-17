//
//  TravelInfoView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 16/06/2023.
//

import SwiftUI

struct TravelInfoView: View {
    @StateObject var vm = TravelInfoViewModel()
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var trainManager: TrainManager
    
    var body: some View {
        NavigationStack(path: $vm.presentedJourneys) {
            List {
                searchTrains
                if let currentJourney = trainManager.currentJourney {
                    trainDetection(currentJourney)
                }
            }.navigationTitle("Reisinformatie")
                .navigationDestination(for: JourneyId.self) { id in
                    JourneyView(journeyId: id)
                }
                .refreshable {
                    await trainManager.getData()
                    locationManager.requestLocation()
                    try? await Task.sleep(for: .seconds(1))
                }
                .alert(isPresented: $vm.errorVisible, error: vm.error) { _ in
                    Button("OK") {}
                } message: { error in
                    Text(error.responseCode?.description ?? error.localizedDescription)
                }

        }
    }
    
    var searchTrains: some View {
        Section("Trein opzoeken") {
            TextField("Treinstelnummer", text: $vm.stockNumber)
                .keyboardType(.numberPad)
                .disabled(vm.isLoading)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            Button("Zoek op") {
                Task { await vm.getJourneyId() }
            }
        }
    }
    
    func trainDetection(_ journey: JourneyPayload) -> some View {
        Section("Treindetectie") {
            NavigationLink(value: journey.productNumbers.first) {
                CurrentTrainView(journey: journey, distance: trainManager.currentTrain?.distance)
            }
        }
    }
}
struct TravelInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TravelInfoView()
            .environmentObject(LocationManager.shared)
            .environmentObject(StationsManager.shared)
    }
}
