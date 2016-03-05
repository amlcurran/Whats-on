//
//  WhatsOnPresenter.swift
//  whatson
//
//  Created by Alex on 05/03/2016.
//  Copyright © 2016 Alex Curran. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class WhatsOnPresenter {

    let eventStore: EKEventStore
    let eventService: SCEventsService

    init(eventStore: EKEventStore, eventService: SCEventsService) {
        self.eventStore = eventStore
        self.eventService = eventService
    }

    func beginPresenting(delegate: WhatsOnPresenterDelegate) {
        eventStore.requestAccessToEntityType(.Event) { (access: Bool, error: NSError?) -> Void in
            if (access) {
                self.fetchEvents({ (source: SCCalendarSource) -> Void in
                    delegate.didUpdateSource(source)
                })
            } else {
                delegate.failedToAccessCalendar(error)
            }
        }
    }

    func fetchEvents(completion: (SCCalendarSource -> Void)) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue) {
            let now = NSDateCalculator().now();
            let source = self.eventService.getCalendarSourceWithInt(14, withSCTime:now);
            dispatch_async(dispatch_get_main_queue()) {
                completion(source);
            };
        };
    }

}

protocol WhatsOnPresenterDelegate {
    func didUpdateSource(source: SCCalendarSource)
    func failedToAccessCalendar(error: NSError?)
}
