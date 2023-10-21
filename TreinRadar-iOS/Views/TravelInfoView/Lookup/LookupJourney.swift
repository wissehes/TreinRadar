//
//  LookupJourney.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 15/10/2023.
//

import SwiftUI

struct LookupJourney: View {
    
    @Binding var path: NavigationPath
    
    @State private var journeyNumber = ""
    @State private var isLoading = false
    @State private var notFound = false
    
    var body: some View {
        Section("Reis opzoeken") {
            TextField("Ritnummer", text: $journeyNumber)
                .keyboardType(.numberPad)
                .disabled(isLoading)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            Button {
                Task { await lookupJourney() }
            } label: {
                HStack(alignment: .center) {
                    Text("Zoek op")
                    Spacer()
                    if isLoading {
                        ProgressView()
                    }
                }
            }.disabled(isLoading)
        }.animation(.easeInOut, value: isLoading)
            .alert("Deze rit kon niet gevonden worden", isPresented: $notFound) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Deze rit kon niet gevonden worden, check het ritnummer nog eens en probeer het opnieuw.")
            }

    }
    
    @MainActor
    func lookupJourney() async {
        guard !journeyNumber.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await API.shared.getJourney(journeyId: journeyNumber)
            path.append(result.productNumbers.first ?? journeyNumber)
        } catch {
            notFound = true
            print(error)
        }
    }
}

struct LookupJourneyPreview: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                LookupJourney(path: $path)
            }.navigationDestination(for: JourneyId.self) { journeyId in
                JourneyView(journeyId: journeyId)
            }
        }
    }
}

#Preview {
    LookupJourneyPreview()
}
