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
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(events, id: \.id) { slot in
                    Text(slot.boundaryStart.formatted(date: .complete, time: .omitted))
                        .labelStyle(.lower)
                        .padding(.top, 8)
                    if let event = slot.items.first {
                        DetailsCard2(calendarItem: event) { coordinate in
                            let item = MKMapItem(placemark: MKPlacemark(placemark: coordinate))
                            item.openInMaps(launchOptions: [:])
                        }
                    } else {
                        EmptySlot {
                            addingSlot = slot
                        }
                    }
                }
//            GeometryReader { (proxy: GeometryProxy) in
//                ZStack {
//                    Path { path in
//                        path.addRelativeArc(center: CGPoint(x: proxy.size.width / 2, y: 200), radius: proxy.size.width / 2, startAngle: .degrees(180), delta: .degrees(180))
//                    }.stroke()
//                        .stroke(lineWidth: 8)
//                        .foregroundColor(Color("secondary"))
//                    let offset = UIScreen.main.bounds.maxY - proxy.frame(in: .global).maxY
//                    let maxOffset: CGFloat = 150
//                    let _ = print(offset)
//                    Circle()
//                        .size(width: 50, height: 50)
//                        .offset(x: offset / maxOffset * proxy.size.width, y: 200 - 200 * sin(offset / maxOffset * .pi))
//                }
//                .frame(minHeight: 250)
//            }
//            .listRowBackground(Color("windowBackground"))
//            .listRowSeparator(.hidden)
            }
        }
        .padding(.horizontal)
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
                                                .withEvent(named: "Another item")]), redaction: .constant([]))
            
                EventList(events: .constant([.empty(duration: 2),
                                    .empty(inFuture: 1, duration: 2)
                                        .withEvent(named: "Bar"),
                                    .empty(inFuture: 2, duration: 2),
                                    .empty(inFuture: 3, duration: 2),
                                    .empty(inFuture: 4, duration: 2)
                                        .withEvent(named: "Foo")
                                                .withEvent(named: "Another item")]), redaction: .constant([.privacy]))
        }
    }
}
