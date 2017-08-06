//
//  CalendarsLoader.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation
import EventKit

class CalendarLoader {

    let eventStore: EKEventStore

    init(eventStore: EKEventStore = .instance) {
        self.eventStore = eventStore
    }

    func load(onSuccess: ([EventCalendar]) -> Void, onError: (Error) -> Void) {
        let ekCalendars = eventStore.calendars(for: .event)
        let calendars = ekCalendars.map(asCalendar)
        onSuccess(calendars)
    }

}

private func asCalendar(_ ekCalendar: EKCalendar) -> EventCalendar {
    return EventCalendar(name: ekCalendar.title, id: EventCalendar.Id(rawValue: ekCalendar.calendarIdentifier))
}

struct EventCalendar {
    let name: String
    //swiftlint:disable:next variable_name
    let id: Id

    //swiftlint:disable:next type_name
    struct Id {
        let rawValue: String
    }
}
