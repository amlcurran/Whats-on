//
//  OptionsView.swift
//  whatson
//
//  Created by Alex Curran on 07/10/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct OptionsView: View {

    @Binding var startDate: Date
    @Binding var endDate: Date
    let allCalendars: [EventCalendar]
    let onDismiss: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        BoundaryPickerView2(startDate: $startDate, endDate: $endDate)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        DefaultCalendarPicker(calendars: allCalendars)
                    }
                    Section(header: Text("Shown calendars"), footer: Text("Only events from checked calendars will be shown in your schedule.")) {
                        ShownCalendarPicker(allCalendars: allCalendars)
                    }
                }
                .listStyle(.insetGrouped)
            }.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        onDismiss()
                    }
                }
            }
        }
        .accentColor(Color("secondary"))
    }

}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(
            startDate: .constant(Date()),
            endDate: .constant(Date().addingTimeInterval(-68000)),
            allCalendars: [
                EventCalendar(name: "Calendar 1", account: "Gmail", id: EventCalendar.Id(rawValue: "foo"), included: true, editable: false),
                EventCalendar(name: "Calendar 2", account: "iCloud", id: EventCalendar.Id(rawValue: "bar"), included: false, editable: true),
                EventCalendar(name: "Calendar 3", account: "Outlook", id: EventCalendar.Id(rawValue: "baz"), included: true, editable: false)
            ]
        ) {
            
        }
    }
}

