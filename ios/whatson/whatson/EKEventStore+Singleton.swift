import Foundation
import EventKit

private let singleton = EKEventStore()

extension EKEventStore {

    static var instance: EKEventStore {
        return singleton
    }

    func event(matching eventItem: SCEventCalendarItem) -> EKEvent? {
        if let itemId = eventItem.id__() {
            return event(withIdentifier: itemId)
        }
        return nil
    }

}
