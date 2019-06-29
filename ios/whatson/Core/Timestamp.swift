//
//  Timestamp.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

struct Timestamp {

    let millis: Int
    private let timeCalculator: TimeCalculator

    func plusDays(days: Int) -> Timestamp {
        return timeCalculator.plusDays(days: days, time: self)
    }

    func daysSinceEpoch() -> Int {
        return timeCalculator.getDays(time: self)
    }

    func plusHours(hours: Int) -> Timestamp {
        return timeCalculator.plusHours(time: self, hours: hours)
    }

    func plusHours(of timeOfDay: TimeOfDay) -> Timestamp {
        return timeCalculator.plusHours(time: self, hours: Int(timeOfDay.hoursInDay()))
    }
}
