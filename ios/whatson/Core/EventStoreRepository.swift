import UIKit
import EventKit

public class EventStoreRepository: EventsRepository {

    let calculator: TimeCalculator
    let predicates: EventPredicates
    let calendarPreferenceStore: CalendarPreferenceStore

    public init(timeRepository: BorderTimeRepository, calendarPreferenceStore: CalendarPreferenceStore) {
        self.calculator = NSDateCalculator.instance
        self.predicates = EventPredicates(timeRepository: timeRepository)
        self.calendarPreferenceStore = calendarPreferenceStore
    }

    public func getCalendarItems(nowTime: Timestamp, nextWeek: Timestamp, fivePm: TimeOfDay, elevenPm: TimeOfDay) -> [CalendarItem] {
        let eventStore = EKEventStore.instance
        let startTime = calculator.date(from: nowTime)
        let endTime = calculator.date(from: nextWeek)
        let calendars = eventStore.supportedCalendars(from: calendarPreferenceStore)
        let search = eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: calendars)
        let allEvents = eventStore.events(matching: search)
        let filtered = allEvents.filter(predicates.defaults)
        return filtered.compactMap { ekEvent -> CalendarItem in
            return EventCalendarItem(eventId: ekEvent.eventIdentifier,
                                     title: ekEvent.title,
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
