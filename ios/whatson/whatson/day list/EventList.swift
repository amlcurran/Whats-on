//
//  EventList.swift
//  whatson
//
//  Created by Alex Curran on 02/03/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import Core
import MapKit
import WidgetKit

struct EventList: View {
    
    @Binding var events: [CalendarSlot]
    @Binding var redaction: RedactionReasons
    @State var addingSlot: CalendarSlot?
    let onDeleteTapped: (EventCalendarItem) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(events, id: \.id) { slot in
                    Text(slot.boundaryStart.formatted(date: .complete, time: .omitted))
                        .labelStyle(.lower)
                        .padding(.top, 8)
                    if let event = slot.items.first {
                        SwipeView(onDeleteTapped: {
                            onDeleteTapped(event)
                        }) {
                            DetailsCard2(calendarItem: event) { coordinate in
                                let item = MKMapItem(placemark: MKPlacemark(placemark: coordinate))
                                item.openInMaps(launchOptions: [:])
                            }
                        }
                    } else {
                        EmptySlot {
                            addingSlot = slot
                        }
                    }
                }
                Spacer(minLength: 16)
//                CuteView()
            }
            .padding([.leading, .bottom, .trailing])
        }
        .redacted(reason: redaction)
        .background(Color("windowBackground"))
        .sheet(item: $addingSlot, onDismiss: nil) { slot in
            AddEventView(slot: slot) {
                addingSlot = nil
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
                EventList(events: .constant([.empty(duration: 2),
                                    .empty(inFuture: 1, duration: 2)
                                        .withEvent(named: "Bar"),
                                    .empty(inFuture: 2, duration: 2),
                                    .empty(inFuture: 3, duration: 2),
                                    .empty(inFuture: 4, duration: 2)
                                        .withEvent(named: "Foo")
                                        .withEvent(named: "Another item")]), redaction: .constant([]), onDeleteTapped: { _ in })
            
                EventList(events: .constant([.empty(duration: 2),
                                    .empty(inFuture: 1, duration: 2)
                                        .withEvent(named: "Bar"),
                                    .empty(inFuture: 2, duration: 2),
                                    .empty(inFuture: 3, duration: 2),
                                    .empty(inFuture: 4, duration: 2)
                                        .withEvent(named: "Foo")
                                        .withEvent(named: "Another item")]), redaction: .constant([.privacy]), onDeleteTapped: { _ in })
        }
    }
}
