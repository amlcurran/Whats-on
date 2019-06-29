import Foundation
import EventKit
import Core

private let singleton = EKEventStore()

extension EKEventStore {

    static var instance: EKEventStore {
        return singleton
    }

    func event(matching eventItem: EventCalendarItem) -> EKEvent? {
        return event(withIdentifier: eventItem.eventId)
    }

}
