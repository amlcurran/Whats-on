//
//  DayViews.swift
//  DayViews
//
//  Created by Alex Curran on 26/08/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI

extension Color {

    static var lightBackground: Color {
        Color(red: 237 / 255, green: 241 / 255, blue: 245 / 255)
    }

    static var darkBackground: Color {
        Color(red: 35 / 255, green: 35 / 255, blue: 43 / 255)
    }

}

private let formatter: DateFormatter = {
    var format = DateFormatter()
    format.timeStyle = .short
    format.dateStyle = .long
    format.doesRelativeDateFormatting = true
    return format
}()

private let dateOnlyFormatter: DateFormatter = {
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
        if let item = slot.firstItem() {
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
            Text(formatter.string(from: item.startTime))
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

struct Background: View {

    let empty: Bool

    var body: some View {
        if empty {
                            ContainerRelativeShape()
                                .stroke(style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [8], dashPhase: 0))
                                .foregroundColor(Color("emptyOutline"))
        } else {
            ContainerRelativeShape()
                                .foregroundColor(Color("surface"))
            }
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
            Text(dateOnlyFormatter.string(from: slot.boundaryStart))
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

public extension CalendarSlot {

    static func empty(inFuture delay: Int = 0,
                      duration: Int) -> CalendarSlot {
        CalendarSlot(boundaryStart: Date() + TimeInterval(delay * 60 * 60),
                     boundaryEnd: Date() + TimeInterval(60 * 60 * (delay + duration)))
    }

    func withEvent(named name: String) -> CalendarSlot {
        var new = self
        new.add(EventCalendarItem(eventId: "abc", title: name, startTime: self.boundaryStart, endTime: self.boundaryEnd))
        return new
    }

}
