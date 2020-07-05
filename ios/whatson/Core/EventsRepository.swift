//
//  EventsRepository.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public protocol EventsRepository {

    func getCalendarItems(between nowTime: Date, and nextWeek: Date, borderStart fivePm: TimeOfDay, borderEnd elevenPm: TimeOfDay) -> [CalendarItem]
}
