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
                     eventStore: EKEventStore = EKEventStore.instance) {
        self.init()
        self.eventStore = eventStore
        self.event = EKEvent(representing: calendarItem)
        self.editViewDelegate = delegate
    }

}

fileprivate extension EKEvent {

    convenience init(representing calendarItem: SCCalendarItem,
                     calculator: NSDateCalculator = .instance,
                     eventStore: EKEventStore = .instance) {
        self.init(eventStore: eventStore)
        self.startDate = calculator.date(from: calendarItem.startTime())
        self.endDate = calculator.date(from: calendarItem.endTime())
    }

}
