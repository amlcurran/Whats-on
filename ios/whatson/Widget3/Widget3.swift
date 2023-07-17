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

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> EventsEntry {
        EventsEntry(date: Date(),
                    slots: [
                        .empty(duration: 5 * 60 * 60),
                        .empty(inFuture: 24 * 60 * 60, duration: 3 * 60 * 60)
                            .withEvent(named: "Dinner with Tim")
                    ])
    }

    func getSnapshot(in context: Context, completion: @escaping (EventsEntry) -> Void) {
        let source = EventsService.default.fetchEvents(inNumberOfDays: 2, startingFrom: Date())
        let entry = EventsEntry(date: Date(), slots: source)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let source = EventsService.default.fetchEvents(inNumberOfDays: 2, startingFrom: Date())

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let refresh = Calendar.current.date(bySettingHour: 2, minute: 0, second: 0, of: tomorrow)

        let timeline = Timeline(entries: [
            EventsEntry(date: Date(), slots: source)
        ], policy: .after(refresh!))
        completion(timeline)
    }
}

struct EventsEntry: TimelineEntry {
    let date: Date
    let slots: [CalendarSlot]
}

struct Widget3EntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Day(slot: entry.slots.first!)
            Day(slot: entry.slots.reversed().first!)
        }
        .padding(10)
        .backgroundCompat(Color("windowBackground"))
        .accentColor(Color("accent"))
    }
}

extension View {
    
    func backgroundCompat(_ color: Color) -> some View {
        if #available(macCatalystApplicationExtension 17.0, *) {
            return containerBackground(Color("windowBackground"), for: .widget)
        } else {
            return background(Color("windowBackground"))
        }
    }
    
}

@main
struct Widget3: Widget {
    let kind: String = "Widget3"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Widget3EntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Coming up")
        .description("Displays what's on today and tomorrow")
    }
}

// swiftlint:disable:next type_name
struct Widget3_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Widget3EntryView(
                entry: EventsEntry(
                    date: Date(),
                    slots: [
                        .empty(duration: 5),
                        .empty(inFuture: 24, duration: 5)
                            .withEvent(named: "Test event 1")
                    ]
                ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Widget3EntryView(
                entry: EventsEntry(
                    date: Date(),
                    slots: [
                        .empty(duration: 5),
                        .empty(inFuture: 24, duration: 5)
                            .withEvent(named: "Test event 1")
                    ]
                ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .preferredColorScheme(.dark)
            Widget3EntryView(
                entry: EventsEntry(
                    date: Date(),
                    slots: [
                        .empty(duration: 5),
                        .empty(inFuture: 24, duration: 5)
                            .withEvent(named: "Test event 1")
                    ]))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
