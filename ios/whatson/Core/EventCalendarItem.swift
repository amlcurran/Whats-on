//
//  EventCalendarItem.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public struct EventCalendarItem: CalendarItem, Equatable, Hashable {

    public let eventId: String
    public let title: String
    public let startTime: Date
    public let endTime: Date
    public let isEmpty: Bool = false

    public init(eventId: String, title: String, startTime: Date, endTime: Date) {
        self.eventId = eventId
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
    }
}
