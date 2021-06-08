//
//  CalendarSlot.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public struct CalendarSlot: Equatable, Hashable {
    public init(boundaryStart: Date, boundaryEnd: Date) {
        self.boundaryStart = boundaryStart
        self.boundaryEnd = boundaryEnd
    }

    private var calendarItems = [EventCalendarItem]()
    public let boundaryStart: Date
    public let boundaryEnd: Date

    public var isEmpty: Bool {
        return calendarItems.isEmpty
    }

    public func firstItem() -> EventCalendarItem? {
        return calendarItems.first
    }

    mutating func add(_ item: EventCalendarItem) {
        calendarItems.append(item)
    }

    public func count() -> Int {
        return calendarItems.count
    }

    public func items() -> [CalendarItem] {
        return calendarItems
    }
}
