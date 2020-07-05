//
//  TimeCalculator.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public protocol TimeCalculator {

    func plusDays(days: Int, time: Timestamp) -> Timestamp
    func add(days: Int, to time: Timestamp) -> Date

    func getDays(time: Timestamp) -> Int

    func plusHours(time: Timestamp, hours: Int) -> Timestamp
    func add(hours: Int, to time: Date) -> Date

    @available(*, deprecated)
    func startOfToday() -> Timestamp
    func dateAtStartOfToday() -> Date

    func time(from date: Date) -> Timestamp
    func date(from time: Timestamp) -> Date

}
