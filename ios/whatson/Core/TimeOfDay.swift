//
//  TimeOfDay.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

struct TimeOfDay {

    let measurement: Measurement<UnitDuration>

    init(millis: Int) {
        self.measurement = Measurement<UnitDuration>(value: Double(millis), unit: .milliseconds)
    }

    private init(measurement: Measurement<UnitDuration>) {
        self.measurement = measurement
    }

    func hoursInDay() -> Double {
        return measurement.converted(to: .hours).value
    }

    func minutesInDay() -> Double {
        return measurement.converted(to: .minutes).value
    }

    static func fromHours(hours: Int) -> TimeOfDay {
        let measurement = Measurement<UnitDuration>(value: Double(hours), unit: .hours)
        return TimeOfDay(measurement: measurement)
    }
}
