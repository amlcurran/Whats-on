//
//  CalendarSlot.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public struct CalendarSlot {
    private var calendarItems = [CalendarItem]()

    public var isEmpty: Bool {
        return calendarItems.isEmpty
    }

    public func firstItem() -> CalendarItem? {
        return calendarItems[0]
    }

    mutating func add(_ item: CalendarItem) {
        calendarItems.append(item)
    }

    public func count() -> Int {
        return calendarItems.count
    }

    public func items() -> [CalendarItem] {
        return calendarItems
    }
}
