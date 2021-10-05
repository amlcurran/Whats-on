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

    public static var `default`: EventsService {
        let timeRepo = UserDefaultsTimeStore()
        let repo = EventKitEventRepository(timeRepository: timeRepo, calendarPreferenceStore: CalendarPreferenceStore())
        return EventsService(timeRepository: timeRepo, eventsRepository: repo)
    }

    public static var demo: EventsService {
        let timeRepo = UserDefaultsTimeStore()
        let repo = DemoEventRepository()
        return EventsService(timeRepository: timeRepo, eventsRepository: repo)
    }

    public init(timeRepository: BorderTimeRepository, eventsRepository: EventsRepository) {
        self.timeRepository = timeRepository
        self.eventsRepository = eventsRepository
    }

    public func fetchEvents(inNumberOfDays numberOfDays: Int, startingFrom startDate: Date) -> [CalendarSlot] {
        let nowTime = Calendar.current.startOfToday
        let nextWeek = Calendar.current.date(byAdding: [
            .day: numberOfDays
        ], to: nowTime)!
        let fivePm = timeRepository.borderTimeStart
        let elevenPm = timeRepository.borderTimeEnd

        let calendarItems = eventsRepository.getCalendarItems(between: nowTime,
                                                              and: nextWeek,
                                                              borderStart: fivePm,
                                                              borderEnd: elevenPm)

        var itemArray = [CalendarSlot]()
        let epochToNow = startDate.daysSinceEpoch()
        for i in 0..<numberOfDays {
            let slot = CalendarSlot(items: [], boundaryStart: startOfTodayBlock(i), boundaryEnd: endOfTodayBlock(i))
            itemArray.append(slot)
        }
        for item in calendarItems {
            let key = item.startTime.daysSinceEpoch() - epochToNow
            itemArray[key] = itemArray[key].appending(item)
        }

        return itemArray
    }

    private func startOfTodayBlock(_ position: Int) -> Date {
        Calendar.current.startOfToday
            .addingComponents([
                .hour: timeRepository.borderTimeStart.hours,
                .day: position
            ])!
    }

    private func endOfTodayBlock(_ position: Int) -> Date {
        Calendar.current.startOfToday
            .addingComponents([
                .hour: timeRepository.borderTimeEnd.hours,
                .day: position
            ])!
    }

}
