//
//  EventCalendarItem.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public struct EventCalendarItem: CalendarItem {

    public let eventId: String
    public let title: String
    public let startTime: Timestamp
    public let endTime: Timestamp
    public let isEmpty: Bool = false

    public init(eventId: String, title: String, startTime: Timestamp, endTime: Timestamp) {
        self.eventId = eventId
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
    }
}
