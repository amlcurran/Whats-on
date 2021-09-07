//
//  CalendarSlot.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public struct CalendarSlot: Equatable, Hashable {
    public init(items: [EventCalendarItem], boundaryStart: Date, boundaryEnd: Date) {
        self.items = items
        self.boundaryStart = boundaryStart
        self.boundaryEnd = boundaryEnd
    }

    public let items: [EventCalendarItem]
    public let boundaryStart: Date
    public let boundaryEnd: Date
}
