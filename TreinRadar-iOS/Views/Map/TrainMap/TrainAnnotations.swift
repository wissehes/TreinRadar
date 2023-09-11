//
//  TrainAnnotations.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 02/09/2023.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct TrainAnnotations: MapContent {
    @EnvironmentObject var trainManager: TrainManager
    @Binding var train: Train?
    
    var body: some MapContent {
        ForEach(trainManager.trains, content: trainAnnotation)
    }
    
    func trainAnnotation(_ train: Train) -> some MapContent {
        Annotation("\(train.snelheid) km", coordinate: train.coordinate, anchor: .center) {
            Circle()
                .fill(train.annotationColor)
                .overlay(train.annotationIcon.foregroundStyle(.white))
                .frame(width: 25, height: 25, alignment: .center)
                .overlay(
                    Image(systemName: "chevron.up")
                        .fontWeight(.medium)
                        .padding([.bottom], 34)
                        .rotationEffect(Angle(degrees: train.richting), anchor: .center)
                )
                .shadow(radius: 2.5)
                .onTapGesture {
                    self.train = train
                }
        }.annotationTitles(.hidden)
    }
}

struct TrainAnnotationIcons {
    var train: Train
    
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

fileprivate extension Train {    
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
    
    var annotationIcon: some View {
        let icons = TrainAnnotationIcons(train: self)
        switch self.type {
        case .ic, .spr:
            return AnyView(icons.textIcon)
        case .arr:
            return AnyView(icons.trainIcon)
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        Map {
            TrainAnnotations(train: .constant(nil))
        }.environmentObject(TrainManager())
    } else {
        EmptyView()
    }
}
