//
//  TimeOfDay.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public struct TimeOfDay {

    private let measurement: Measurement<UnitDuration>

    init(millis: Int) {
        self.measurement = Measurement<UnitDuration>(value: Double(millis / 1000), unit: .seconds)
    }

    private init(measurement: Measurement<UnitDuration>) {
        self.measurement = measurement
    }

    public func hoursInDay() -> Double {
        return measurement.converted(to: .hours).value
    }

    public func minutesInDay() -> Double {
        return measurement.converted(to: .minutes).value
    }

    public static func fromHours(hours: Int, andMinutes minutes: Int) -> TimeOfDay {
        let measurement = Measurement<UnitDuration>(value: Double(hours), unit: .hours)
        let minutes = Measurement<UnitDuration>(value: Double(minutes), unit: .minutes)
        return TimeOfDay(measurement: measurement + minutes)
    }
}
