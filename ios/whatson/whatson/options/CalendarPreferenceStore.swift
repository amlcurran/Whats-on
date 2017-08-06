//
//  CalendarPreferenceStore.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation

class CalendarPreferenceStore {

    private let userDefaults: UserDefaults
    private let calendarsKey = "excludedCalendars"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var excludedCalendars: [EventCalendar.Id] {
        get {
            if let stringIds = userDefaults.array(forKey: calendarsKey) as? [String] {
                return stringIds.map { EventCalendar.Id(rawValue: $0) }
            }
            return []
        }
        set {
            userDefaults.set(newValue.map({ $0.rawValue }), forKey: calendarsKey)
        }
    }

}
