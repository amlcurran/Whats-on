//
//  CalendarSource.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public class CalendarSource {

    let calendarItems: [CalendarSlot]
    let timeCalculator: TimeCalculator
    let timeRepository: BorderTimeRepository

    init(calendarItems: [CalendarSlot], timeCalculator: TimeCalculator, timeRepository: BorderTimeRepository) {
        self.calendarItems = calendarItems
        self.timeCalculator = timeCalculator
        self.timeRepository = timeRepository
    }

    public func count() -> Int {
        return calendarItems.count
    }

    public func slotAt(_ position: Int) -> CalendarSlot {
        return calendarItems[position]
    }

    public func isEmptySlot(at position: Int) -> Bool {
        return slotAt(position).isEmpty
    }
}
