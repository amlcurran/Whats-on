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

    public static func standard() -> EventsService {
        let timeRepo = NSDateTimeRepository()
        let repo = EventStoreRepository(timeRepository: timeRepo, calendarPreferenceStore: CalendarPreferenceStore())
        return EventsService(timeRepository: timeRepo, eventsRepository: repo, timeCalculator: NSDateCalculator.instance)
    }

    public init(timeRepository: BorderTimeRepository, eventsRepository: EventsRepository, timeCalculator: TimeCalculator) {
        self.timeRepository = timeRepository
        self.eventsRepository = eventsRepository
        self.timeCalculator = timeCalculator
    }

    public func getCalendarSource(numberOfDays: Int, now: Date) -> CalendarSource {
        let nowTime = timeCalculator.dateAtStartOfToday()
        let nextWeek = timeCalculator.add(days: numberOfDays, to: nowTime)
        let fivePm = timeRepository.borderTimeStart
        let elevenPm = timeRepository.borderTimeEnd

        let calendarItems = eventsRepository.getCalendarItems(between: nowTime, and: nextWeek, borderStart: fivePm, borderEnd: elevenPm)

        var itemArray = [Int: CalendarSlot]()
        let epochToNow = timeCalculator.daysSinceEpoch(in: now)
        for item in calendarItems {
            let key = timeCalculator.daysSinceEpoch(in: item.startTime) - epochToNow
            var slot = itemArray[key] ?? CalendarSlot()
            slot.add(item)
            itemArray[key] = slot
        }

        return CalendarSource(calendarItems: itemArray, daysSize: numberOfDays, timeCalculator: timeCalculator, timeRepository: timeRepository)
    }

}
