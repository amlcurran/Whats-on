//
//  EventList.swift
//  whatson
//
//  Created by Alex Curran on 02/03/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

struct EventList: View {
    
    @Binding var events: [CalendarSlot]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                ForEach(events) { slot in
                    Spacer(minLength: 16)
                    Text(slot.boundaryStart.formatted(date: .complete, time: .omitted))
                        .labelStyle(.lower)
                    if let event = slot.items.first {
                        DetailsCard2(viewState: Event(title: event.title, location: event.location, startDate: event.startTime, endDate: event.endTime)) 
                    } else {
                        EmptySlot()
                    }
                }
            }
        }
        .padding()
        .background(Color("windowBackground"))
    }
    
}

struct EmptySlot: View {
    
    var body: some View {
        Text("Empty")
            .labelStyle(.lower)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background  {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 8, dash: [8, 8], dashPhase: 0))
                    .foregroundColor(Color("lightText"))
            }
    }
    
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList(events: .constant([.empty(duration: 2),
                            .empty(inFuture: 1, duration: 2)
                                .withEvent(named: "Bar"),
                            .empty(inFuture: 2, duration: 2),
                            .empty(inFuture: 3, duration: 2),
                            .empty(inFuture: 4, duration: 2)
                                .withEvent(named: "Foo")
                                .withEvent(named: "Another item")]))
    }
}
