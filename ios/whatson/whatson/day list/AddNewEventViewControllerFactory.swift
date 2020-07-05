//
//  AddNewEventViewControllerFactory.swift
//  whatson
//
//  Created by Alex Curran on 08/11/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation
import EventKitUI
import Core

class AddNewEventViewControllerFactory {

    func newEventController(for calendarItem: CalendarItem, delegate: EKEventEditViewDelegate) -> UIViewController {
        let eventController = EKEventEditViewController(calendarItem: calendarItem, delegate: delegate)
        eventController.modalPresentationStyle = .formSheet
        return eventController
    }

}

fileprivate extension EKEventEditViewController {

    convenience init(calendarItem: CalendarItem,
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

    convenience init(representing calendarItem: CalendarItem,
                     calculator: TimeCalculator = NSDateCalculator.instance,
                     eventStore: EKEventStore = .instance,
                     preferenceStore: CalendarPreferenceStore) {
        self.init(eventStore: eventStore)
        if let defaultCalendarId = preferenceStore.defaultCalendar?.rawValue {
            self.calendar = eventStore.calendar(withIdentifier: defaultCalendarId)
        }
        self.startDate = calendarItem.startTime
        self.endDate = calendarItem.endTime
    }

}
