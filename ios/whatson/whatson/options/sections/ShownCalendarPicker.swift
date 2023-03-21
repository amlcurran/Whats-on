//
//  ShownCalendarPicker.swift
//  whatson
//
//  Created by Alex Curran on 10/10/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import SwiftUI
import Core

private class Storage<Value>: ObservableObject {
  @Published var value: Value

  init(value: Value) {
    self.value = value
  }
}

@propertyWrapper
struct CodableAppStorage<T>: DynamicProperty {

    @StateObject private var _value: Storage<T>
    let key: String
    let store: UserDefaults
    let setter: (T) -> Void

    var wrappedValue: T {
        get {
            return _value.value
        }
        nonmutating set {
            setter(newValue)
            _value.value = newValue
        }
    }

}

extension CodableAppStorage where T: Codable {

    init(wrappedValue: T, _ key: String, store: UserDefaults) {
        let value: T = store.codable(forKey: key) ?? wrappedValue
        self.init(_value: Storage(value: value), key: key, store: store) {
            store.setCodable($0, forKey: key)
        }
    }

}

struct ShownCalendarPicker: View {

    let allCalendars: [EventCalendar]
    @CodableAppStorage("excludedCalendars", store: .appGroup) var excludedCalendars: [EventCalendar.Id] = []

    var body: some View {
        ForEach(allCalendars) { calendar in
            CalendarLine(
                calendar: calendar,
                checked: !excludedCalendars.contains(calendar.id)
            ).onTapGesture {
                self.excludedCalendars = excludedCalendars.toggle(calendar.id)
            }
        }
    }
}

struct CalendarLine: View {

    let calendar: EventCalendar
    let checked: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(calendar.name)
                Text(calendar.account)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if checked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("accent"))
            }
             //   .visible(!excludedCalendars.contains(calendar.id))
        }
    }

}

struct VisibilityModifier: ViewModifier {

    let visible: Bool

    func body(content: Content) -> some View {
        content.opacity(visible ? 1 : 0)
    }

}

extension View {

    func visible(_ bool: Bool) -> some View {
        modifier(VisibilityModifier(visible: bool))
    }

}

struct ShownCalendarPicker_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ShownCalendarPicker(allCalendars: [
                EventCalendar(name: "Calendar 1", account: "Gmail", id: EventCalendar.Id(rawValue: "foo"), included: true, editable: false),
                EventCalendar(name: "Calendar 2", account: "iCloud", id: EventCalendar.Id(rawValue: "bar"), included: false, editable: true),
                EventCalendar(name: "Calendar 3", account: "Outlook", id: EventCalendar.Id(rawValue: "baz"), included: true, editable: false)
            ], excludedCalendars: [EventCalendar.Id(rawValue: "foo")])
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
