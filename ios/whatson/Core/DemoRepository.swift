//
//  DemoRepository.swift
//  whatson
//
//  Created by Alex Curran on 26/09/2021.
//  Copyright © 2021 Alex Curran. All rights reserved.
//

import Foundation

public class DemoEventRepository: EventsRepository {

    public func getCalendarItems(between startTime: Date, and endTime: Date, borderStart fivePm: TimeOfDay, borderEnd elevenPm: TimeOfDay) -> [EventCalendarItem] {
        return [
            .named("Board game night", delayDays: 1, hours: 18.5, duration: 5),
            .named("Dinner out", delayDays: 3, hours: 19.0, duration: 5),
            .named("Board game night", delayDays: 6, hours: 20.5, duration: 5)
        ].filter { $0.endTime < endTime }
    }

}
