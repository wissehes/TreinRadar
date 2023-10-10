//
//  TrainPartsView.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 07/10/2023.
//

import SwiftUI

/// Displays the train parts next to eachother in an HStack
struct TrainPartsView: View {
    
    @Environment(\.displayScale) var displayScale
    
    var journey: JourneyPayload?
    var live: LiveTrain?
    
    var trainPartsFromJourney: [TrainPart]? {
        journey?.currentOrNextStop?.actualStock?.trainParts
    }
    
    var trainPartsFromInfo: [LiveTrainImage]? {
        live?.images
    }
    
    var facilities: [PlatformFacility] {
        live?.platformFacilities?.filter { $0.paddingLeft >= -100 } ?? []
    }
    
    var resizeFactor: Double? {
        guard let train = trainPartsFromInfo?.first else { return nil }
        let standardHeight = 60.0
        let heightPixels = standardHeight * displayScale
        let resizeFactor = train.height / heightPixels
        print("Train height", train.height)
        print("Actual height", heightPixels)
        print("By height:", resizeFactor)
        return resizeFactor
        
    }
    
    /// geoWidth = width of the container in points.
    func facilityItemWidth(geoWidth: Double, myWidth: Double) -> Double {
        // Total width of all images in pixels
        guard let totalWidthOfImages = trainPartsFromInfo?.reduce(0.0, { partialResult, item in
            partialResult + item.width
        }) else { return 0 }
        
        let containerWidthPixels = geoWidth * displayScale
        resizeFactor
        let resizeFactor = containerWidthPixels / totalWidthOfImages
        print(resizeFactor)
        // previously: 0.340711175616836
        return myWidth * resizeFactor
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal) {
                VStack(alignment: .leading) {
                    if let trainPartsFromInfo = trainPartsFromInfo {
                        imagesFromInfo(trainPartsFromInfo)
                    } else if let trainPartsFromJourney = trainPartsFromJourney {
                        imagesFromJourney(trainPartsFromJourney)
                    }
                    
                    if trainPartsFromInfo != nil {
                        HStack(alignment: .center) {
                            ForEach(facilities, id: \.paddingLeft) { facility in
                                Text(facility.description)
                                    .frame(width: facilityItemWidth(geoWidth: geo.size.width, myWidth: facility.width))
                            }
                        }
                    }
                }.onAppear { facilityItemWidth(geoWidth: geo.size.width, myWidth: 0) }
            }
        }.frame(height: 100)
    }
    
    func imagesFromJourney(_ trainParts: [TrainPart]) -> some View {
        HStack(alignment: .center, spacing: 2.5) {
            ForEach(trainParts, id: \.stockIdentifier, content: renderImage)
        }
    }
    
    func imagesFromInfo(_ images: [LiveTrainImage]) -> some View {
        HStack(alignment: .center, spacing: 2.5) {
            ForEach(images, id: \.url) { image in
                AsyncImage(url: URL(string: image.url)) { image in
                    image.resizable().scaledToFit()//.scaleEffect(0.35)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 60)
            }
        }
    }
    
    func renderImage(_ part: TrainPart) -> some View {
        AsyncImage(url: URL(string: part.image?.uri ?? "")) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            ProgressView()
        }.frame(height: 60)
    }
}

#Preview {
    List {
        TrainPartsView(
            journey: try? MockData().getData(resource: "journey", type: JourneyPayload.self),
            live: try? MockData().getData(resource: "live", type: LiveTrain.self)
        )
    }
}
