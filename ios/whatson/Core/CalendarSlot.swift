//
//  CalendarSlot.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

struct CalendarSlot {
    private var calendarItems = [CalendarItem]()

    var isEmpty: Bool {
        return calendarItems.isEmpty
    }

    func firstItem() -> CalendarItem? {
        return calendarItems[0]
    }

    mutating func add(_ item: CalendarItem) {
        calendarItems.append(item)
    }

    func count() -> Int {
        return calendarItems.count
    }

    func items() -> [CalendarItem] {
        return calendarItems
    }
}
