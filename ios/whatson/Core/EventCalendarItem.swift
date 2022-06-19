//
//  EventCalendarItem.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Contacts
import EventKit

public struct EventCalendarItem: CalendarItem, Equatable, Hashable {

    public let eventId: String
    public let title: String
    public let location: String?
    public let startTime: Date
    public let endTime: Date
    public let isEmpty: Bool = false
    public let attendees: [Attendee]
    public let event: EKEvent

    public init(eventId: String, title: String, location: String?, startTime: Date, endTime: Date, attendees: [Attendee], event: EKEvent) {
        self.eventId = eventId
        self.title = title
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.attendees = attendees
        self.event = event
    }
}

public struct Attendee: Equatable, Hashable, Identifiable {
    
    public init(identifier: String, givenName: String, familyName: String, image: Data? = nil) {
        self.identifier = identifier
        self.givenName = givenName
        self.familyName = familyName
        self.image = image
    }
    
    public let identifier: String
    public let givenName: String
    public let familyName: String
    public let image: Data?
    
    public var id: String {
        identifier
    }
    
    public var initials: String {
        return [givenName, familyName].map { String($0.first ?? Character(" ")) }.joined().uppercased()
    }
}
