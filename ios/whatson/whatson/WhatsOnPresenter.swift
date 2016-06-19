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

    func beginPresenting(_ delegate: WhatsOnPresenterDelegate) {
        eventStore.requestAccess(to: .event) { (access: Bool, error: NSError?) -> Void in
            if (access) {
                self.fetchEvents({ (source: SCCalendarSource) -> Void in
                    delegate.didUpdateSource(source)
                })
            } else {
                delegate.failedToAccessCalendar(error)
            }
        }
    }

    func fetchEvents(_ completion: ((SCCalendarSource) -> Void)) {
        let queue = DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault);
        queue.async {
            let now = NSDateCalculator().now();
            let source = self.eventService.getCalendarSource(with: 14, with:now);
            DispatchQueue.main.async { [weak source] in
                if let source = source {
                    completion(source);
                }
            };
        };
    }

}

protocol WhatsOnPresenterDelegate {
    func didUpdateSource(_ source: SCCalendarSource)
    func failedToAccessCalendar(_ error: NSError?)
}
