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

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct Widget3EntryView: View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            Day(title: "First event",
                time: Date())
            Day(title: "Second event",
                time: Date().addingTimeInterval(60 * 60 * 24))
        }
        .background(Color("windowBackground"))
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

struct Day: View {

    var isEmpty: Bool = false
    let title: String
    let time: Date

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .foregroundColor(Color("surface"))

            VStack(alignment: .leading) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(time, style: .time)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
            }
            .padding(8)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
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
            Widget3EntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Widget3EntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .preferredColorScheme(.dark)
            Widget3EntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
