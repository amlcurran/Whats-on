//
//  NSDate+Time.swift
//  whatson
//
//  Created by Alex on 27/02/2016.
//  Copyright © 2016 Alex Curran. All rights reserved.
//

import UIKit

extension Date {

    init(from time: SCTimestamp) {
        self.init(timeIntervalSince1970: TimeInterval(time.getMillis() / 1000))
    }

    static func startTime(from timeStore: UserDefaultsTimeStore, addingDays days: Int) -> Date? {
        var components = Calendar.current.dateComponents([.day, .minute, .hour, .second, .month, .year], from: Date())
        components.hour = timeStore.startTime
        components.minute = 0
        components.day = components.day.or(0) + days
        return Calendar.current.date(from: components)
    }

    static func endTime(from timeStore: UserDefaultsTimeStore, addingDays days: Int) -> Date? {
        var components = Calendar.current.dateComponents([.day, .minute, .hour, .second, .month, .year], from: Date())
        components.hour = timeStore.endTime
        components.minute = 0
        components.day = components.day.or(0) + days
        return Calendar.current.date(from: components)
    }

}
