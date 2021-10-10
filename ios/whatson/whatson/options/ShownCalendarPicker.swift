//
//  ShownCalendarPicker.swift
//  whatson
//
//  Created by Alex Curran on 10/10/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

struct ShownCalendarPicker: View {

    @Binding var allCalendars: [EventCalendar]
    @State var excludedCalendars: [EventCalendar.Id]

    var body: some View {
        ForEach(allCalendars) { calendar in
            HStack {
                VStack(alignment: .leading) {
                    Text(calendar.name)
                    Text(calendar.account)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if !excludedCalendars.contains(where: { $0 == calendar.id }) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("accent"))
                }
            }.onTapGesture {
                self.excludedCalendars = excludedCalendars.toggle(calendar.id)
            }
        }
    }
}

struct ShownCalendarPicker_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ShownCalendarPicker(allCalendars: .constant([
                EventCalendar(name: "Calendar 1", account: "Gmail", id: EventCalendar.Id(rawValue: "foo"), included: true, editable: false),
                EventCalendar(name: "Calendar 2", account: "iCloud", id: EventCalendar.Id(rawValue: "bar"), included: false, editable: true),
                EventCalendar(name: "Calendar 3", account: "Outlook", id: EventCalendar.Id(rawValue: "baz"), included: true, editable: false)
            ]), excludedCalendars: [EventCalendar.Id(rawValue: "foo")])
        }
    }
}

extension Array where Element: Equatable {

    func toggle(_ element: Element) -> [Element] {
        if self.contains(element) {
            return self.filter { $0 != element }
        } else {
            return self + [element]
        }
    }

}
