//
//  CalendarSource.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public class CalendarSource {

    let calendarItems: [Int: CalendarSlot]
    let daysSize: Int
    let timeCalculator: TimeCalculator
    let timeRepository: BorderTimeRepository

    init(calendarItems: [Int: CalendarSlot], daysSize: Int, timeCalculator: TimeCalculator, timeRepository: BorderTimeRepository) {
        self.calendarItems = calendarItems
        self.daysSize = daysSize
        self.timeCalculator = timeCalculator
        self.timeRepository = timeRepository
    }

    public func count() -> Int {
        return daysSize
    }

    public func item(at position: Int) -> CalendarItem? {
        let calendarSlot = calendarItems[position]
        if calendarSlot == nil || calendarSlot!.isEmpty {
            let startTime = startOfTodayBlock(position)
            let endTime = endOfTodayBlock(position)
            return EmptyCalendarItem(startTime: startTime, endTime: endTime)
        }
        return calendarSlot?.firstItem()
    }

    private func startOfTodayBlock(_ position: Int) -> Date {
        let one = timeCalculator.add(hours: timeRepository.borderTimeStart.hours, to: timeCalculator.dateAtStartOfToday())
        return timeCalculator.add(days: position, to: one)
    }

    private func endOfTodayBlock(_ position: Int) -> Date {
        let one = timeCalculator.add(hours: timeRepository.borderTimeEnd.hours, to: timeCalculator.dateAtStartOfToday())
        return timeCalculator.add(days: position, to: one)
    }

    public func slotAt(_ position: Int) -> CalendarSlot {
        return calendarItems[position] ?? CalendarSlot()
    }

    public func isEmptySlot(at position: Int) -> Bool {
        return slotAt(position).isEmpty
    }
}
