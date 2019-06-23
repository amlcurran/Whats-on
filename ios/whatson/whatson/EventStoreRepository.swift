import UIKit
import EventKit

@objc class EventStoreRepository: NSObject, SCEventsRepository {

    let calculator: NSDateCalculator
    let predicates: EventPredicates
    let calendarPreferenceStore: CalendarPreferenceStore

    init(timeRepository: SCTimeRepository, calendarPreferenceStore: CalendarPreferenceStore) {
        self.calculator = NSDateCalculator.instance
        self.predicates = EventPredicates(timeRepository: timeRepository)
        self.calendarPreferenceStore = calendarPreferenceStore
    }

    public func getCalendarItems(with nowTime: SCTimestamp!,
                                 with nextWeek: SCTimestamp!,
                                 with fivePm: SCTimeOfDay!,
                                 with elevenPm: SCTimeOfDay!) -> JavaUtilList {
        let eventStore = EKEventStore.instance
        let startTime = calculator.date(from: nowTime)
        let endTime = calculator.date(from: nextWeek)
        let calendars = eventStore.supportedCalendars(from: calendarPreferenceStore)
        let search = eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: calendars)
        let allEvents = eventStore.events(matching: search)
        let filtered = allEvents.filter(predicates.defaults)
        let items = filtered.compactMap { ekEvent in
            return SCEventCalendarItem(nsString: ekEvent.eventIdentifier,
                    with: ekEvent.title,
                    with: self.calculator.time(from: ekEvent.startDate),
                    with: self.calculator.time(from: ekEvent.endDate))
        }
        return items.toJavaList()
    }

}

fileprivate extension Array {

    func toJavaList() -> JavaUtilList {
        let list = JavaUtilArrayList()
        for item in self {
            list.add(withId: item)
        }
        return list
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
