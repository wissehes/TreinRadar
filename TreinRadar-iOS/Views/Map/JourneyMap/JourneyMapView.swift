//
//  JourneyMapView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 24/09/2023.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct JourneyMapView: View {
    
    /// The stops and geometry data
    var data: StopsAndGeometry
    /// Live train data for showing the icon on the map
    var liveTrain: LiveTrain?
    /// Whether this map is inline or a regular interactive map
    var inline = false
    
    var body: some View {
        Map(interactionModes: inline ? [] : .all) {
            MapPolyline(coordinates: data.actualCoordinates)
                .stroke(.blue, lineWidth: 3)
            
            ForEach(data.stops, id: \.uicCode) { stop in
                Marker(stop.name, systemImage: "tram", coordinate: stop.coordinates)
                    .foregroundStyle(.blue)
            }
            
            trainMarker
            
        }.mapStyle(.standard(pointsOfInterest: [.publicTransport]))
    }
    
    @MapContentBuilder
    var trainMarker: some MapContent {
        if let live = liveTrain, let image = live.image {
            Annotation("\(live.speed) km/h", coordinate: live.location) {
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    EmptyView()
                }.frame(width: 50, height: 25)

            }
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        JourneyMapView(
            data: try! MockData().getData(resource: "stops-geometry", type: StopsAndGeometry.self), 
            liveTrain: .init(
                latitude: 52.5,
                longitude: 5,
                speed: 20,
                direction: 50,
                track: nil,
                image: "https://trein.wissehes.nl/api/image/DDZ%204"
            )
        )
    } else {
        EmptyView()
    }
}
