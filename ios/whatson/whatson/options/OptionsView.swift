//
//  OptionsView.swift
//  whatson
//
//  Created by Alex Curran on 07/10/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

struct OptionsView: View {

    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var shownCalendars: [EventCalendar]
    @Binding var defaultCalendar: EventCalendar.Id?

    var body: some View {
        VStack {
            BoundaryPickerView2()
            Form {
                Section(header: Text("Options")) {
                    DefaultCalendarPicker(selection: $defaultCalendar,
                                          calendars: shownCalendars)
                }
                Section(header: Text("Shown calendars")) {
                    ForEach(shownCalendars) { calendar in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(calendar.name)
                                Text(calendar.account)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if calendar.included {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("accent"))
                            }
                        }
                    }
                }
            }
        }.tint(Color("accent"))
    }

    @ViewBuilder
    func DefaultCalendarPicker(selection: Binding<EventCalendar.Id?>, calendars: [EventCalendar]) -> some View {
        Picker("Default calendar", selection: selection) {
            ForEach(calendars.filter(\.editable)) { calendar in
                HStack {
                    Text(calendar.name)
                    Spacer()
                    if selection.wrappedValue == calendar.id {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color("accent"))
                    }
                }
                .tag(calendar.id)
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
            shownCalendars: .constant([
                EventCalendar(name: "Calendar 1", account: "Gmail", id: EventCalendar.Id(rawValue: "foo"), included: true, editable: false),
                EventCalendar(name: "Calendar 2", account: "iCloud", id: EventCalendar.Id(rawValue: "bar"), included: false, editable: true),
                EventCalendar(name: "Calendar 3", account: "Outlook", id: EventCalendar.Id(rawValue: "baz"), included: true, editable: false)
            ]),
            defaultCalendar: .constant(EventCalendar.Id(rawValue: "bar"))
        )
    }
}

