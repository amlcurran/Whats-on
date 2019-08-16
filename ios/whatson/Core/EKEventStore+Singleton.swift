import Foundation
import EventKit

private let singleton = EKEventStore()

public extension EKEventStore {

    static var instance: EKEventStore {
        return singleton
    }

    func event(matching eventItem: EventCalendarItem) -> EKEvent? {
        return event(withIdentifier: eventItem.eventId)
    }

}
