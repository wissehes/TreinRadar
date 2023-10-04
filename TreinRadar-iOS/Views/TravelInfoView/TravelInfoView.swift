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
    @EnvironmentObject var stationsManager: StationsManager
    
    var body: some View {
        NavigationStack(path: $vm.presentedJourneys) {
            List {
                searchTrains
                
                if locationManager.permissionStatus == .authorizedWhenInUse {
                    trainDetection
                    nearbyStations
                }
            }.navigationTitle("Reisinformatie")
                .navigationDestination(for: JourneyId.self) { id in
                    JourneyView(journeyId: id)
                }
                .navigationDestination(for: StationWithDistance.self) { station in
                    StationView(station: station)
                }
                .animation(.easeInOut, value: trainManager.currentJourney)
                .animation(.easeInOut, value: stationsManager.nearbyStations)
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
    
    var trainDetection: some View {
        Section("Treindetectie") {
            if let journey = trainManager.currentJourney {
                NavigationLink(value: journey.productNumbers.first) {
                    CurrentTrainView(journey: journey, distance: trainManager.currentTrain?.distance)
                }
            } else {
                HStack(alignment: .center) {
                    Text("Trein detecteren...")
                        .foregroundStyle(.secondary)
                    Spacer()
                    ProgressView()
                }
            }
        }
    }
    
    var nearbyStations: some View {
        Section("Stations in de buurt") {
            if let nearbyStations = stationsManager.nearbyStations {
                ForEach(nearbyStations.prefix(3), id: \.code) { station in
                    NavigationLink(station.name, value: station)
                }
            } else {
                HStack(alignment: .center) {
                    Text("Stations ophalen...")
                        .foregroundStyle(.secondary)
                    Spacer()
                    ProgressView()
                }
            }
        }
    }
    
}
struct TravelInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TravelInfoView()
            .environmentObject(LocationManager.shared)
            .environmentObject(StationsManager.shared)
            .environmentObject(TrainManager.shared)
    }
}
