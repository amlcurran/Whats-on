//
//  OptionsView.swift
//  whatson
//
//  Created by Alex Curran on 07/10/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

@propertyWrapper
struct CodableAppStorage<T: Codable> {

    let key: String
    let store: UserDefaults

    var wrappedValue: T? {
        get {
            if let json = store.string(forKey: key),
                let jsonData = json.data(using: .utf8) {
                return try? JSONDecoder().decode(T.self, from: jsonData)
            } else {
                return nil
            }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let jsonString = String(data: data, encoding: .utf8) {
                store.set(jsonString, forKey: key)
            }

        }
    }

}

struct OptionsView: View {

    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var allCalendars: [EventCalendar]
    @AppStorage("defaultCalendar", store: .appGroup) var defaultCalendar: EventCalendar.Id?
    @Binding var excludedCalendars: [EventCalendar.Id]

    var body: some View {
        VStack {
            BoundaryPickerView2()
                .padding(.top)
            List {
                Section(header: Text("Options")) {
                    DefaultCalendarPicker(defaultCalendar: $defaultCalendar,
                                          calendars: allCalendars)
                }
                Section(header: Text("Shown calendars")) {
                    ShownCalendarPicker(allCalendars: $allCalendars,
                                        excludedCalendars: excludedCalendars)
                }
            }
        }
    }

    @ViewBuilder
    func BoundaryPickerView2() -> some View {
        VStack {
            Text("Show events between")
            HStack {
                DatePicker("",
                           selection: $startDate,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                Text("and")
                DatePicker("",
                           selection: $endDate,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
        }
    }

}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(
            startDate: .constant(Date()),
            endDate: .constant(Date().addingTimeInterval(-68000)),
            allCalendars: .constant([
                EventCalendar(name: "Calendar 1", account: "Gmail", id: EventCalendar.Id(rawValue: "foo"), included: true, editable: false),
                EventCalendar(name: "Calendar 2", account: "iCloud", id: EventCalendar.Id(rawValue: "bar"), included: false, editable: true),
                EventCalendar(name: "Calendar 3", account: "Outlook", id: EventCalendar.Id(rawValue: "baz"), included: true, editable: false)
            ]),
            excludedCalendars: .constant([EventCalendar.Id(rawValue: "foo")])
        )
    }
}

