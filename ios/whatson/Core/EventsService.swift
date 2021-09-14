//
//  EventsService.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public class EventsService {

    private let timeRepository: BorderTimeRepository
    private let eventsRepository: EventsRepository
    private let timeCalculator: TimeCalculator

    public static var `default`: EventsService {
        let timeRepo = NSDateTimeRepository()
        let repo = EventKitEventRepository(timeRepository: timeRepo, calendarPreferenceStore: CalendarPreferenceStore())
        return EventsService(timeRepository: timeRepo, eventsRepository: repo, timeCalculator: NSDateCalculator.instance)
    }

    public init(timeRepository: BorderTimeRepository, eventsRepository: EventsRepository, timeCalculator: TimeCalculator) {
        self.timeRepository = timeRepository
        self.eventsRepository = eventsRepository
        self.timeCalculator = timeCalculator
    }

    public func fetchEvents(inNumberOfDays numberOfDays: Int, startingFrom startDate: Date) -> [CalendarSlot] {
        let nowTime = timeCalculator.dateAtStartOfToday()
        let nextWeek = timeCalculator.add(days: numberOfDays, to: nowTime)
        let fivePm = timeRepository.borderTimeStart
        let elevenPm = timeRepository.borderTimeEnd

        let calendarItems = eventsRepository.getCalendarItems(between: nowTime,
                                                              and: nextWeek,
                                                              borderStart: fivePm,
                                                              borderEnd: elevenPm)

        var itemArray = [CalendarSlot]()
        let epochToNow = timeCalculator.daysSinceEpoch(in: startDate)
        for i in 0..<numberOfDays {
            let slot = CalendarSlot(items: [], boundaryStart: startOfTodayBlock(i), boundaryEnd: endOfTodayBlock(i))
            itemArray.append(slot)
        }
        for item in calendarItems {
            let key = timeCalculator.daysSinceEpoch(in: item.startTime) - epochToNow
            itemArray[key] = itemArray[key].appending(item)
        }

        return itemArray
    }

    private func startOfTodayBlock(_ position: Int) -> Date {
        let one = timeCalculator.add(hours: timeRepository.borderTimeStart.hours, to: timeCalculator.dateAtStartOfToday())
        return timeCalculator.add(days: position, to: one)
    }

    private func endOfTodayBlock(_ position: Int) -> Date {
        let one = timeCalculator.add(hours: timeRepository.borderTimeEnd.hours, to: timeCalculator.dateAtStartOfToday())
        return timeCalculator.add(days: position, to: one)
    }

}
