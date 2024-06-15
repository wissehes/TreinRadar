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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    time
                    Text(item.product.longCategoryName)
                }
                Text(item.station)
                    .bold()
                    .foregroundStyle(item.cancelled ? .red : .accentColor)
                
                Text(departureTime)
                
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
    
    var time: some View {
        HStack(alignment: .center, spacing: 2.5) {
            Text(item.plannedDateTime, format: .dateTime.hour().minute())
                .bold()
                .strikethrough(item.cancelled)
            
            if item.delay != 0 {
                Text("+\(item.delay)")
                    .foregroundStyle(.red)
                    .bold()
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

#Preview {
    NavigationStack {
        TimeTableView(
            stationCode: "VTN",
            sporen: [1, 4],
            naam: "Vleuten"
        )
    }
}


//#Preview {
//    DepartureItemView()
//}
