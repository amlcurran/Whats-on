//
//  EventCalendarItem.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

struct EventCalendarItem: CalendarItem {

    let eventId: String
    let title: String
    let startTime: Timestamp
    let endTime: Timestamp

    func id() -> String {
        return eventId
    }

    let isEmpty: Bool = false
}
