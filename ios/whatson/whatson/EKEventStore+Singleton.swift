import Foundation
import EventKit

private let singleton = EKEventStore()

extension EKEventStore {

    static var instance: EKEventStore {
        return singleton
    }

}
