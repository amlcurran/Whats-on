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
        .padding(10)
        .background(Color("windowBackground"))
        .accentColor(Color("accent"))
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
            Widget3EntryView(
                entry: SimpleEntry(
                    date: Date(),
                    slots: [
                        .empty(duration: 5),
                        .empty(inFuture: 24, duration: 5)
                            .withEvent(named: "Test event 1")
                    ],
                    configuration: ConfigurationIntent()
                ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Widget3EntryView(
                entry: SimpleEntry(
                    date: Date(),
                    slots: [
                        .empty(duration: 5),
                        .empty(inFuture: 24, duration: 5)
                            .withEvent(named: "Test event 1")
                    ],
                    configuration: ConfigurationIntent()
                ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .preferredColorScheme(.dark)
            Widget3EntryView(
                entry: SimpleEntry(
                    date: Date(),
                    slots: [
                        .empty(duration: 5),
                        .empty(inFuture: 24, duration: 5)
                            .withEvent(named: "Test event 1")
                    ],
                    configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
