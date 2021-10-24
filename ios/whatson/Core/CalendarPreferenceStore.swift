//
//  CalendarPreferenceStore.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation

public extension UserDefaults {

    func codable<T: Codable>(forKey key: String) -> T? {
        if let string = self.string(forKey: key),
           let jsonData = string.data(using: .utf8),
           let decoded = try? JSONDecoder().decode(T.self, from: jsonData) {
            return decoded
        } else {
            return nil
        }
    }

    func setCodable<T: Codable>(_ codable: T, forKey key: String) {
        if let foo = try? JSONEncoder().encode(codable),
           let jsonString = String(data: foo, encoding: .utf8) {
            self.set(jsonString, forKey: key)
        }
    }

}

public class CalendarPreferenceStore {

    private let userDefaults: UserDefaults
    private let calendarsKey = "excludedCalendars"
    private let defaultCalendarKey = "defaultCalendar"

    public init(userDefaults: UserDefaults = .appGroup) {
        self.userDefaults = userDefaults
    }

    public var excludedCalendars: [EventCalendar.Id] {
        get {
            userDefaults.codable(forKey: calendarsKey) ?? []
        }
        set {
            userDefaults.setCodable(newValue, forKey: calendarsKey)
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
