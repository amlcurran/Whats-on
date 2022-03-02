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
    let onEmptyTapped: (CalendarSlot) -> Void
    
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
                        EmptySlot {
                            onEmptyTapped(slot)
                        }
                    }
                }
            }
            .padding(.bottom, 32)
            .padding(.horizontal)
        }
        .background(Color("windowBackground"))
    }
    
}

struct EmptySlot: View {
    
    var onTapped: () -> Void
    @State var isTapped = false
    
    var body: some View {
        Text("Empty")
            .labelStyle(.lower)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        onTapped()
                    }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { _ in
                        if !isTapped {
                            isTapped = true
                        }
                    }
                    .onEnded { _ in
                        isTapped = false
                    }
            )
            .background  {
                ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 8, dash: [8, 8], dashPhase: 0))
                    .foregroundColor(Color("lightText"))
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color("lightText"))
                        .opacity(isTapped ? 0.3 : 0.0)
                        .scaleEffect(x: isTapped ? 1.0 : 0.9, y: 1.0, anchor: .center)
                        .animation(.easeInOut.speed(3), value: isTapped)
                        
                }
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
                                        .withEvent(named: "Another item")])) { _ in }
    }
}
