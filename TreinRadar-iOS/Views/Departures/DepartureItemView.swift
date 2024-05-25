//
//  DepartureItemView.swift
//  TreinRadar
//
//  Created by Wisse Hes on 05/07/2023.
//

import SwiftUI

struct DepartureItemView: View {
    
    var item: any TimeTableItem
    var chosenMessageStyle: ChosenMessageStyle
    
    var relativeFormatter = RelativeDateTimeFormatter()
    
    var filteredMessages: [Message] {
        switch chosenMessageStyle {
        case .all:
            return item.messages
        case .specific(let messageStyle):
            return item.messages.filter {
                $0.style == messageStyle
            }
        }
    }
    
    var departureTime: String {
        let date = item.actualDateTime
        let diff = Int(date.timeIntervalSince1970 - Date.now.timeIntervalSince1970)
        
        if diff < 60 {
            return "over < 1 minuut"
        } else {
            return self.relativeFormatter.localizedString(for: item.actualDateTime, relativeTo: .now)
        }
    }
    
    var delayTime: Int {
        let planned = item.plannedDateTime
        let actual = item.actualDateTime
        let diff = Int(actual.timeIntervalSince1970  - planned.timeIntervalSince1970)
        let components = Calendar.current.dateComponents([.minute], from: planned, to: actual)
        
        guard let minutes = components.minute, diff > 30 else { return 0 }
        return minutes
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(item.product.longCategoryName)
                        .font(.callout)
                    Text(item.product.number)
                        .font(.caption)
                }
                Text(item.station)
                    .bold()
                    .foregroundStyle(item.cancelled ? .red : .accentColor)
                
                HStack(alignment: .center, spacing: 5) {
                    Text(departureTime)
                    
                    if delayTime != 0 {
                        Text(verbatim: "(+\(delayTime))")
                            .foregroundStyle(.red)
                    }
                }
                
                if !filteredMessages.isEmpty {
                    messages
                }
            }
            
            Spacer()
            
            if let track = item.actualTrack, !item.cancelled {
                VStack(alignment: .center) {
                    Text("Spoor")
                        .font(.subheadline)
                    Text(track)
                        .bold()
                }
                
            }
            
            if item.cancelled {
                Image(systemName: "exclamationmark.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .foregroundStyle(.red)
                    .font(.system(size: 25))
                    .frame(width: 40, height: 40)
            }
        }
    }
    
    var messages: some View {
        VStack(alignment: .leading) {
            ForEach(filteredMessages, id: \.message) { msg in
                Text(msg.message)
                    .font(.subheadline)
                    .italic()
                    .multilineTextAlignment(.leading)
                    .padding([.top, .bottom], 0.5)
            }
        }.padding(.top, 0.5)
    }
}

struct DepartureItemView_Previews: PreviewProvider {
    static var data: [Departure] {
        let data = try? MockData().getData(resource: "departures", type: [Departure].self)
        return data ?? []
    }
    
    static var previews: some View {
        NavigationStack {
            List(self.data, id: \.name) { dep in
                DepartureItemView(item: dep, chosenMessageStyle: .all)
            }
        }
    }
}

//#Preview {
//    DepartureItemView()
//}
