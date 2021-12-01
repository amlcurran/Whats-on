//
//  DefaultCalendarPicker.swift
//  whatson
//
//  Created by Alex Curran on 10/10/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

struct DefaultCalendarPicker: View {

    let calendars: [EventCalendar]

    var body: some View {
        DefaultCalendarPicker2(calendars: calendars)
    }
}

struct DefaultCalendarPicker2: View {

    @AppStorage("defaultCalendar", store: .appGroup) var defaultCalendar: EventCalendar.Id?
    let calendars: [EventCalendar]

    var body: some View {
        Picker("Default calendar", selection: $defaultCalendar) {
            ForEach(calendars.filter(\.editable)) { calendar in
                Text(calendar.name)
                    .tag(Optional.some(calendar.id))
            }
        }
    }
}

struct DefaultCalendarPicker_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            DefaultCalendarPicker2(
                calendars: .previews
            )
            DefaultCalendarPicker2(
                calendars: .previews
            )
        }
    }
}

extension Array where Element == EventCalendar {

    static var previews: [EventCalendar] {
        [
            EventCalendar(name: "Calendar 1", account: "Gmail", id: EventCalendar.Id(rawValue: "foo"), included: true, editable: false),
            EventCalendar(name: "Calendar 2", account: "iCloud", id: EventCalendar.Id(rawValue: "bar"), included: false, editable: true),
            EventCalendar(name: "Calendar 3", account: "Outlook", id: EventCalendar.Id(rawValue: "baz"), included: true, editable: false)
        ]
    }

}

#if targetEnvironment(macCatalyst)

//extension AppStorage where AppStorage.Value: RawRepresentable {
//
//}

#endif
