//
//  CalendarsLoader.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation
import EventKit

public class CalendarLoader {

    let eventStore: EKEventStore
    let preferenceStore: CalendarPreferenceStore

    public init(eventStore: EKEventStore = .instance, preferenceStore: CalendarPreferenceStore) {
        self.eventStore = eventStore
        self.preferenceStore = preferenceStore
    }

    public func load() -> [EventCalendar] {
        let ekCalendars = eventStore.calendars(for: .event)
        let excludedCalendars = preferenceStore.excludedCalendars
        return ekCalendars.map({ ekCalendar -> EventCalendar in
            let calendarId = EventCalendar.Id(rawValue: ekCalendar.calendarIdentifier)
            return EventCalendar(name: ekCalendar.title,
                                 account: ekCalendar.source.title,
                                 id: calendarId,
                                 included: excludedCalendars.contains(calendarId) == false,
                                 editable: ekCalendar.allowsContentModifications)
        })
    }

}

public struct EventCalendar: Identifiable, Hashable, Equatable {
    public init(name: String, account: String, id: EventCalendar.Id, included: Bool, editable: Bool) {
        self.name = name
        self.account = account
        self.id = id
        self.included = included
        self.editable = editable
    }


    public let name: String
    public let account: String
    //swiftlint:disable:next variable_name
    public let id: Id
    public let included: Bool
    public let editable: Bool

    //swiftlint:disable:next type_name
    public struct Id: RawRepresentable, Codable, Hashable {
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public let rawValue: String
    }

}

extension Array where Element == EventCalendar {

    public var onlyEditable: [EventCalendar] {
        return filter { calendar in
            calendar.editable
        }
    }

}
