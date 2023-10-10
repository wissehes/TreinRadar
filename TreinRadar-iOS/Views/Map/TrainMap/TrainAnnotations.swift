//
//  TrainAnnotations.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 02/09/2023.
//

import SwiftUI
import MapKit
import Defaults

@available(iOS 17.0, *)
struct TrainAnnotations: MapContent {
    @EnvironmentObject var trainManager: TrainManager

    var body: some MapContent {
        ForEach(trainManager.trains, content: trainAnnotation)
    }
    
    func trainAnnotation(_ train: LiveTrain) -> some MapContent {
        Annotation(train.id, coordinate: train.coordinate, anchor: .center) {
            TrainAnnotation(train: train)
        }.annotationTitles(.hidden)
            .tag(SelectedMapItem.train(train))
    }
    
    func formattedSpeed(speed: Double) -> String {
        let measurement = Measurement(value: speed, unit: UnitSpeed.kilometersPerHour)
        return MeasurementFormatter.kmhFormatter.string(from: measurement)
    }
}

struct TrainAnnotation: View {
    @Default(.rotateTrainIcons) var shouldRotateTrains

    var train: LiveTrain
    
    var shouldMirrorImage: Bool { 
        shouldRotateTrains && train.direction > 0 && train.direction < 180
    }
    
    var imageRotation: Angle {
        if shouldRotateTrains {
            Angle(degrees: train.direction + 90)
        } else {
            Angle()
        }
    }
    
    var body: some View {
        if let imageUrl = URL(string: train.image ?? "") {
            imageIcon(imageUrl: imageUrl)
        } else {
            circleIcon
        }
    }
    
    func imageIcon(imageUrl: URL) -> some View {
        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .scaledToFit()
                .scaleEffect(x: 1, y: shouldMirrorImage ? -1 : 1)
                .rotationEffect(imageRotation, anchor: .center)
                .animation(.easeInOut, value: shouldRotateTrains)
        } placeholder: {
            EmptyView()
        }.frame(width: 50, height: 25)
    }

    
    var circleIcon: some View {
        Circle()
            .fill(train.annotationColor)
            .overlay(annotationIcon.foregroundStyle(.white))
            .frame(width: 25, height: 25, alignment: .center)
            .overlay(
                Image(systemName: "chevron.up")
                    .fontWeight(.medium)
                    .padding([.bottom], 34)
                    .rotationEffect(Angle(degrees: train.direction), anchor: .center)
            )
    }
    
    var annotationIcon: some View {
        switch train.type {
        case .ic, .spr:
            return AnyView(Text(train.type.rawValue)
                .lineLimit(1)
                .minimumScaleFactor(0.005)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .scaledToFit()
                .padding(2.5))
        case .arr:
            return AnyView(Image(systemName: "train.side.front.car")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(2.5))
        }
    }
    
    var textIcon: some View {
        Text(train.type.rawValue)
            .lineLimit(1)
            .minimumScaleFactor(0.005)
            .font(.system(.subheadline, design: .rounded, weight: .bold))
            .scaledToFit()
            .padding(2.5)
    }
    
    var trainIcon: some View {
        Image(systemName: "train.side.front.car")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(2.5)
    }
}

fileprivate extension LiveTrain {
    var annotationColor: Color {
        switch self.type {
        case .ic:
            return .blue
        case .spr:
            return .cyan
        case .arr:
            return .red
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        Map {
            TrainAnnotations()
        }.environmentObject(TrainManager.shared)
            .task { await TrainManager.shared.getData() }
    } else {
        EmptyView()
    }
}
