import UIKit
import EventKit

public class EventKitEventRepository: EventsRepository {

    let predicates: EventPredicates
    let calendarPreferenceStore: CalendarPreferenceStore

    public init(timeRepository: BorderTimeRepository, calendarPreferenceStore: CalendarPreferenceStore) {
        self.predicates = EventPredicates(timeRepository: timeRepository)
        self.calendarPreferenceStore = calendarPreferenceStore
    }

    public func getCalendarItems(between startTime: Date, and endTime: Date, borderStart fivePm: TimeOfDay, borderEnd elevenPm: TimeOfDay) -> [EventCalendarItem] {
        let eventStore = EKEventStore.instance
        let calendars = eventStore.supportedCalendars(from: calendarPreferenceStore)
        let search = eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: calendars)
        let allEvents = eventStore.events(matching: search)
        let filtered = allEvents.filter(predicates.defaults)
        return filtered.compactMap { ekEvent -> EventCalendarItem in
            return EventCalendarItem(eventId: ekEvent.eventIdentifier,
                                     title: ekEvent.title,
                                     location: ekEvent.location,
                                     startTime: ekEvent.startDate,
                                     endTime: ekEvent.endDate)
        }
    }

}

private extension EKEventStore {

    func supportedCalendars(from preferences: CalendarPreferenceStore) -> [EKCalendar] {
        let excludedCalendars = preferences.excludedCalendars
        return calendars(for: .event).filter({ (calendar) -> Bool in
            return excludedCalendars.doesNotContainCalendar(withId: calendar.calendarIdentifier)
        })
    }

}

private extension Array where Element == EventCalendar.Id {

    func doesNotContainCalendar(withId identifier: String) -> Bool {
        return contains(where: { excludedId in
            return excludedId.rawValue == identifier
        }) == false
    }

}
