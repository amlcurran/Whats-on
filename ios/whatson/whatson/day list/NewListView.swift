//
//  NewListView.swift
//  whatson
//
//  Created by Alex Curran on 15/02/2022.
//  Copyright © 2022 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

struct NewListView: View {
    
    @State var slots: [CalendarSlot] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(slots, id: \.boundaryStart) { slot in
                switch slot.items.count {
                case 0:
                    EventCardView(item: .or(slot))
                        .padding(.horizontal)
                case 1:
                    EventCardView(item: .either(slot.items.first!))
                        .padding(.horizontal)
                default:
                    GeometryReader { proxy in
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(slot.items, id: \.eventId) { item in
                                    EventCardView(item: .either(item))
                                        .frame(minWidth: proxy.size.width * 0.8, alignment: .leading)
                                }
                            }
                        }
                    }.padding(.horizontal)
                }
            }
        }
        .onAppear {
//            presenter.beginPresenting()
        }
        .background(Color("windowBackground"))
    }
}

extension EitherOr where Either == CalendarItem , Or == CalendarSlot {
    
    var style: SlotStyle {
        switch self {
        case .either:
            return .full
        case .or:
            return .empty
        }
    }
    
}

struct EventCardView: View {
    
    let item: EitherOr<CalendarItem, CalendarSlot>
    
    var body: some View {
        VStack(alignment: .leading) {
            switch item {
            case .either(let event):
                Text(event.title)
                    .foregroundColor(Color(uiColor: item.style.mainText))
                Text(event.startTime.formatted(date: .omitted, time: .shortened))
                    .foregroundColor(Color(uiColor: item.style.secondaryText))
            case .or:
                Text("Add event")
                    .foregroundColor(Color(uiColor: item.style.mainText))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8], dashPhase: 0))
                .foregroundColor(Color(uiColor: item.style.borderColor))
        )
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(uiColor: item.style.cellBackground))
        )
    }
    
}

enum EitherOr<Either, Or> {
    case either(Either)
    case or(Or)
}

struct NewListView_Previews: PreviewProvider {
    static var previews: some View {
        NewListView(slots: [
            .empty(duration: 2),
            .empty(inFuture: 1, duration: 2)
                .withEvent(named: "Bar"),
            .empty(inFuture: 2, duration: 2),
            .empty(inFuture: 3, duration: 2),
            .empty(inFuture: 4, duration: 2)
                .withEvent(named: "Foo")
                .withEvent(named: "Another item")
        ])
    }
}
