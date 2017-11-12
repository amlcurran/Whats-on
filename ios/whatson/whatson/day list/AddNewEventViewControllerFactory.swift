//
//  AddNewEventViewControllerFactory.swift
//  whatson
//
//  Created by Alex Curran on 08/11/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation
import EventKitUI

class AddNewEventViewControllerFactory {

    func newEventController(for calendarItem: SCCalendarItem, delegate: EKEventEditViewDelegate) -> UIViewController {
        return EKEventEditViewController(calendarItem: calendarItem, delegate: delegate)
    }

}

fileprivate extension EKEventEditViewController {

    convenience init(calendarItem: SCCalendarItem,
                     delegate: EKEventEditViewDelegate,
                     eventStore: EKEventStore = EKEventStore.instance,
                     calendarPreferenceStore: CalendarPreferenceStore = CalendarPreferenceStore()) {
        self.init()
        self.eventStore = eventStore
        self.event = EKEvent(representing: calendarItem, preferenceStore: calendarPreferenceStore)
        self.editViewDelegate = delegate
    }

}

fileprivate extension EKEvent {

    convenience init(representing calendarItem: SCCalendarItem,
                     calculator: NSDateCalculator = .instance,
                     eventStore: EKEventStore = .instance,
                     preferenceStore: CalendarPreferenceStore) {
        self.init(eventStore: eventStore)
        if let defaultCalendarId = preferenceStore.defaultCalendar?.rawValue {
            self.calendar = eventStore.calendar(withIdentifier: defaultCalendarId)
        }
        self.startDate = calculator.date(from: calendarItem.startTime())
        self.endDate = calculator.date(from: calendarItem.endTime())
    }

}
