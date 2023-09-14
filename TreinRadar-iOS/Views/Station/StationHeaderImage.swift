//
//  StationHeaderImage.swift
//  TreinRadar-iOS
//
//  Created by Wisse Hes on 13/09/2023.
//

import SwiftUI

struct StationHeaderImage: View {
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable().scaledToFill()
            .frame(height: 250)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

//#Preview {
//    List {
//        StationHeaderImage(station: try! MockData().getData(resource: "station", type: FullStation.self))
//    }
//}
