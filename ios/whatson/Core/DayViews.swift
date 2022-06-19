//
//  DayViews.swift
//  DayViews
//
//  Created by Alex Curran on 26/08/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI
import EventKit

extension Color {

    static var lightBackground: Color {
        Color(red: 237 / 255, green: 241 / 255, blue: 245 / 255)
    }

    static var darkBackground: Color {
        Color(red: 35 / 255, green: 35 / 255, blue: 43 / 255)
    }

}

private let dayAndTime: DateFormatter = {
    var format = DateFormatter()
    format.timeStyle = .short
    format.dateStyle = .long
    format.doesRelativeDateFormatting = true
    return format
}()

private let dayOnly: DateFormatter = {
    var format = DateFormatter()
    format.timeStyle = .none
    format.dateStyle = .long
    format.doesRelativeDateFormatting = true
    return format
}()

public struct Day: View {

    let slot: CalendarSlot

    public init(slot: CalendarSlot) {
        self.slot = slot
    }

    public var body: some View {
        if let item = slot.items.first {
            FullSlot(item: item)
        } else {
            EmptySlot(slot: slot)
        }
    }

}

struct FullSlot: View {

    let item: CalendarItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .minimumScaleFactor(0.7)
                .foregroundColor(Color("secondary"))
                .font(.system(size: 14).weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(item.startTime, formatter: dayAndTime)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color("lightText"))
                .lineLimit(1)
                .font(.caption)
        }
        .padding(8)
        .modifier(SlotStyle(empty: false))
    }
}

struct SlotStyle: ViewModifier {

    let empty: Bool

    func body(content: Content) -> some View {
        if empty {
            ZStack {
                ContainerRelativeShape()
                    .stroke(style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [8], dashPhase: 0))
                    .foregroundColor(Color("emptyOutline"))
                content
            }
        } else {
            ZStack {
                ContainerRelativeShape()
                    .foregroundColor(Color("surface"))
                content
            }
        }
    }

}

struct EmptySlot: View {

    let slot: CalendarSlot

    var body: some View {
        VStack(alignment: .leading) {
            Text("Nothing on")
                .minimumScaleFactor(0.7)
                .foregroundColor(Color("emptyOutline"))
                .font(.system(size: 14).weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(slot.boundaryStart, formatter: dayOnly)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color("lightText"))
                .lineLimit(1)
                .font(.caption)
        }
        .padding(8)
        .modifier(SlotStyle(empty: true))
    }

}

@available(iOSApplicationExtension 15.0, *)
// swiftlint:disable:next type_name
struct Slots_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Day(slot: .empty(duration: 5))
                .previewLayout(.sizeThatFits)
                .padding()

            Day(
                slot: .empty(duration: 5)
                    .withEvent(named: "Test event")
            )
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()

            Day(slot: .empty(inFuture: 24, duration: 5))
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}

extension CalendarSlot: Identifiable {
    public var id: Date {
        boundaryStart
    }
}

public extension CalendarSlot {

    static func empty(inFuture delay: Int = 0,
                      duration: Int) -> CalendarSlot {
        CalendarSlot(items: [], boundaryStart: Date() + TimeInterval(delay * 60 * 60),
                     boundaryEnd: Date() + TimeInterval(60 * 60 * (delay + duration)))
    }

    func withEvent(named name: String) -> CalendarSlot {
        let foo: EKEvent! = nil
        let newItem = EventCalendarItem(eventId: "\(name.hashValue)", title: name, location: nil, startTime: self.boundaryStart, endTime: self.boundaryEnd, attendees: [], event: foo)
        return CalendarSlot(items: self.items + [newItem],
                            boundaryStart: self.boundaryStart,
                            boundaryEnd: self.boundaryEnd)
    }

    func appending(_ eventItem: EventCalendarItem) -> CalendarSlot {
        CalendarSlot(items: self.items + [eventItem],
                            boundaryStart: self.boundaryStart,
                            boundaryEnd: self.boundaryEnd)
    }

}

public extension EventCalendarItem {

    static func named(_ name: String, delayDays: Int, hours: Double, duration: Int) -> EventCalendarItem {
        let start = Date().startOfDay(in: .current)! + TimeInterval(delayDays * 24 * 60 * 60) + TimeInterval(hours * 60 * 60)
        let end = start + TimeInterval(60 * 60 * duration)
        let foo: EKEvent! = nil
        return EventCalendarItem(eventId: "\(name.hashValue)",
                                 title: name,
                                 location: nil,
                                 startTime: start,
                                 endTime: end,
                                 attendees: [],
                                 event: foo)
    }

}
