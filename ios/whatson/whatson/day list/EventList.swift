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

enum Multiple<T> {
    case none
    case single(T)
    case multiple([T])
}

extension Array {
    
    var asMultiple: Multiple<Element> {
        if count == 0 {
            return .none
        }
        if count == 1 {
            return .single(first!)
        }
        return .multiple(self)
    }
    
}

struct MultipleEventView: View {
    
    let events: [EventCalendarItem]
    @State var contentSize: CGSize = .zero
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top) {
                ForEach(events, id: \.eventId) { event in
                    DetailsCard2(calendarItem: event) { coordinate in
                        let item = MKMapItem(placemark: MKPlacemark(placemark: coordinate))
                        item.openInMaps(launchOptions: [:])
                    }
                    .if(!contentSize.width.isZero) {
                        $0.frame(width: 0.8 * contentSize.width)
                    }
                    
                }
            }.padding(.bottom, 4)
                .padding([.leading, .trailing])
        }
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        contentSize = geo.size
                    }
            }
        }
    }
}

struct EventList: View {
    
    @Binding var slots: [CalendarSlot]
    @Binding var redaction: RedactionReasons
    @State var addingSlot: CalendarSlot?
    let onDeleteTapped: (EventCalendarItem) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(slots, id: \.id) { slot in
                    Text(slot.boundaryStart.formatted(date: .complete, time: .omitted))
                        .labelStyle(.lower)
                        .padding(.top, 8)
                        .padding([.leading, .trailing])
                    switch slot.items.asMultiple {
                    case .none:
                        EmptySlot()
                            .onTapGesture {
                                addingSlot = slot
                            }
                            .padding([.leading, .trailing])
                    case .single(let event):
                        SwipeView(onDeleteTapped: {
                            onDeleteTapped(event)
                        }) {
                            DetailsCard2(calendarItem: event) { coordinate in
                                let item = MKMapItem(placemark: MKPlacemark(placemark: coordinate))
                                item.openInMaps(launchOptions: [:])
                            }
                        }
                        .padding([.leading, .trailing])
                    case .multiple(let events):
                        MultipleEventView(events: events)
                    }
                }
                Spacer(minLength: 16)
//                CuteView()
            }
        }
        .animation(.easeInOut, value: slots)
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
            
                EventList(slots: .constant([.empty(duration: 2),
                                    .empty(inFuture: 1, duration: 2)
                                        .withEvent(named: "Bar"),
                                    .empty(inFuture: 2, duration: 2),
                                    .empty(inFuture: 3, duration: 2),
                                    .empty(inFuture: 4, duration: 2)
                                        .withEvent(named: "Foo")
                                        .withEvent(named: "Another item")]), redaction: .constant([]), onDeleteTapped: { _ in })
            
                EventList(slots: .constant([.empty(duration: 2),
                                    .empty(inFuture: 1, duration: 2)
                                        .withEvent(named: "Bar"),
                                    .empty(inFuture: 2, duration: 2),
                                    .empty(inFuture: 3, duration: 2),
                                    .empty(inFuture: 4, duration: 2)
                                        .withEvent(named: "Foo")
                                        .withEvent(named: "Another item")]), redaction: .constant([.privacy]), onDeleteTapped: { _ in })
        }
        .previewDevice("iPhone 13 Pro")
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

extension View {
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
}
