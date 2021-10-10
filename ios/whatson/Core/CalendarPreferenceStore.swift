//
//  CalendarPreferenceStore.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation

public class CalendarPreferenceStore {

    private let userDefaults: UserDefaults
    private let calendarsKey = "excludedCalendars"
    private let defaultCalendarKey = "defaultCalendar"

    public init(userDefaults: UserDefaults = .appGroup) {
        self.userDefaults = userDefaults
    }

    public var excludedCalendars: [EventCalendar.Id] {
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

    public var defaultCalendar: EventCalendar.Id? {
        get {
            if let rawId = userDefaults.string(forKey: defaultCalendarKey) {
                return EventCalendar.Id(rawValue: rawId)
            } else {
                return nil
            }
        }
        set {
            if let rawId = newValue?.rawValue {
                userDefaults.set(rawId, forKey: defaultCalendarKey)
            } else {
                userDefaults.set(nil, forKey: defaultCalendarKey)
            }
        }
    }

}

public extension UserDefaults {

    static var appGroup = UserDefaults(suiteName: "group.uk.co.amlcurran.social")!

}
