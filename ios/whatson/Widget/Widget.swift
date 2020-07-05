//
//  Widget.swift
//  Widget
//
//  Created by Alex Curran on 03/07/2020.
//  Copyright © 2020 Alex Curran. All rights reserved.
//

import WidgetKit
import SwiftUI
import Core

struct Provider: TimelineProvider {

    private let eventsService = EventsService.standard()

    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let testDate = Calendar.current.date(bySetting: .hour, value: 19, of: Date())!
        let dayDate = Calendar.current.date(bySetting: .hour, value: 18, of: Date())!
        let entry = SimpleEntry(days: [
            Day(event: Event(name: "Hot yoga", date: testDate), startTime: dayDate),
            Day(event: nil, startTime: Calendar.current.date(byAdding: .day, value: +1, to: Date())!)
        ])
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> Void) {

        DispatchQueue.global(qos: .default).async {
            let events = self.eventsService.getCalendarSource(numberOfDays: 2, now: .now)
            let calculator = NSDateCalculator.instance

            var dayEntries: [Day] = []
            for i in 0..<events.count() {
                let event = events.item(at: i).map { eventItem in
                    Event(name: eventItem.title, date: eventItem.startTime)
                }

                if events.isEmptySlot(at: i) {
                    dayEntries.append(Day(event: nil, startTime: event!.date))
                } else {
                    dayEntries.append(Day(event: event, startTime: event!.date))
                }

            }

            let timeline = Timeline(entries: [
                SimpleEntry(days: dayEntries)
            ], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct Event {
    let name: String
    let date: Date
}

struct Day: Identifiable {
    let event: Event?
    let startTime: Date
    let id = UUID()

    var date: Date {
        event?.date ?? startTime
    }
}

struct SimpleEntry: TimelineEntry {
    public let days: [Day]

    var date: Date {
        Calendar.current.date(byAdding: .hour, value: -1, to: days.first!.date)!
    }
}

struct PlaceholderView: View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct WidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        ForEach(entry.days[0..<2]) { day in
            if let event = day.event {
                EventView(event: event)
            } else {
                FreeDayView(day: day)
            }
        }
    }
}

struct EventView: View {

    let event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name)
                .fontWeight(.semibold)
                .foregroundColor(Color("secondary"))
            Text(event.date, style: .time)
        }
    }

}

struct FreeDayView: View {

    let day: Day

    var body: some View {
        VStack(alignment: .leading) {
            Text("Free")
                .fontWeight(.semibold)
                .foregroundColor(Color("secondary"))
            Text(day.startTime, style: .time)
        }
    }

}

@main
struct WhatsOnWidget: Widget {
    private let kind: String = "Widget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WhatsOnWidgetPreviews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
