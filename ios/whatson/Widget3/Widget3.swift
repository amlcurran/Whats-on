//
//  Widget3.swift
//  Widget3
//
//  Created by Alex Curran on 22/08/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import Core

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    slots: [
                        .empty(duration: 5 * 60 * 60),
                        .empty(inFuture: 24 * 60 * 60, duration: 5 * 60 * 60)
                    ],
                    configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let timeRepo = NSDateTimeRepository()
        let eventService = EventsService(timeRepository: timeRepo,
                                         eventsRepository: EventKitEventRepository(timeRepository: timeRepo,
                                                                                   calendarPreferenceStore: CalendarPreferenceStore()),
                                         timeCalculator: NSDateCalculator.instance)

        let source = eventService.getCalendarSource(numberOfDays: 2, now: Date())
        let slots = [
            source.slotAt(0),
            source.slotAt(1)
        ]

        let entry = SimpleEntry(date: Date(), slots: slots, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let timeRepo = NSDateTimeRepository()
        let eventService = EventsService(timeRepository: timeRepo,
                                         eventsRepository: EventKitEventRepository(timeRepository: timeRepo,
                                                                                   calendarPreferenceStore: CalendarPreferenceStore()),
                                         timeCalculator: NSDateCalculator.instance)

        let source = eventService.getCalendarSource(numberOfDays: 2, now: Date())
        let slots = [
            source.slotAt(0),
            source.slotAt(1)
        ]

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let refresh = Calendar.current.date(bySettingHour: 0, minute: 1, second: 0, of: tomorrow)

        let timeline = Timeline(entries: [
            SimpleEntry(date: Date(), slots: slots, configuration: configuration)
        ], policy: .after(refresh!))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let slots: [CalendarSlot]
    let configuration: ConfigurationIntent
}

struct Widget3EntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Day(slot: entry.slots.first!)
            Day(slot: entry.slots.reversed().first!)
        }
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 10)
        .background(Color("windowBackground"))
        .accentColor(Color("accent"))
    }
}

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

extension CalendarSlot {

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

struct Day: View {

    var isEmpty: Bool = false
    let slot: CalendarSlot

    var body: some View {
        VStack(spacing: 0) {
            if let item = slot.firstItem() {
                FullSlot(item: item)
            } else {
                EmptySlot(slot: slot)
            }
        }
        .frame(maxWidth: .infinity)
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

@main
struct Widget3: Widget {
    let kind: String = "Widget3"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Widget3EntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

// swiftlint:disable:next type_name
struct Widget3_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Widget3EntryView(entry: SimpleEntry(date: Date(),
                                                slots: [
                                                    .empty(duration: 5),
                                                    .empty(inFuture: 24, duration: 5)
                                                        .withEvent(named: "Test event 1")
                                                ],
                                                configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Widget3EntryView(entry: SimpleEntry(date: Date(),slots: [
                .empty(duration: 5),
                .empty(inFuture: 24, duration: 5)
                    .withEvent(named: "Test event 1")
            ],
                                                configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .preferredColorScheme(.dark)
            Widget3EntryView(entry: SimpleEntry(date: Date(),slots: [
                .empty(duration: 5),
                .empty(inFuture: 24, duration: 5)
                    .withEvent(named: "Test event 1")
            ],
                                                configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
