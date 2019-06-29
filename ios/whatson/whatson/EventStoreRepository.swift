import UIKit
import EventKit
import Core

@objc class EventStoreRepository: NSObject, EventsRepository {

    let calculator: NSDateCalculator
    let predicates: EventPredicates
    let calendarPreferenceStore: CalendarPreferenceStore

    init(timeRepository: TimeRepository, calendarPreferenceStore: CalendarPreferenceStore) {
        self.calculator = NSDateCalculator.instance
        self.predicates = EventPredicates(timeRepository: timeRepository)
        self.calendarPreferenceStore = calendarPreferenceStore
    }


    func getCalendarItems(nowTime: Timestamp, nextWeek: Timestamp, fivePm: TimeOfDay, elevenPm: TimeOfDay) -> [CalendarItem] {
        let eventStore = EKEventStore.instance
        let startTime = calculator.date(from: nowTime)
        let endTime = calculator.date(from: nextWeek)
        let calendars = eventStore.supportedCalendars(from: calendarPreferenceStore)
        let search = eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: calendars)
        let allEvents = eventStore.events(matching: search)
        let filtered = allEvents.filter(predicates.defaults)
        return filtered.compactMap { ekEvent in
            return EventCalendarItem(eventId: ekEvent.eventIdentifier,
                                     title: ekEvent.title,
                                     startTime: self.calculator.time(from: ekEvent.startDate),
                                     endTime: self.calculator.time(from: ekEvent.endDate))
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
