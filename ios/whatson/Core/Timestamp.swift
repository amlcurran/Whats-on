//
//  Timestamp.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public struct Timestamp {

    public let millis: Int
    private let timeCalculator: TimeCalculator

    public init(millis: Int, timeCalculator: TimeCalculator) {
        self.millis = millis
        self.timeCalculator = timeCalculator
    }

    public func plusDays(days: Int) -> Timestamp {
        return timeCalculator.plusDays(days: days, time: self)
    }

    func daysSinceEpoch() -> Int {
        return timeCalculator.getDays(time: self)
    }

    @available(*, deprecated)
    public func plusHours(hours: Int) -> Timestamp {
        return timeCalculator.plusHours(time: self, hours: hours)
    }

    @available(*, deprecated)
    func plusHours(of timeOfDay: TimeOfDay) -> Timestamp {
        return timeCalculator.plusHours(time: self, hours: Int(timeOfDay.hoursInDay()))
    }
}
