import Foundation
import EventKit

enum EventResponse {
    case accepted
    case declined
    case maybe
    case none

    var asStatus: EKEventStatus {
        switch self {
        case .accepted:
            return .confirmed
        case .maybe:
            return .tentative
        case .declined:
            return .canceled
        case .none:
            return .none
        }
    }
}

extension EKEvent {

    var response: EventResponse {
        switch status {
        case .confirmed:
            return .accepted
        case .canceled:
            return .declined
        case .tentative:
            return .maybe
        case .none:
            return .none
        }
    }

    var supportsResponses: Bool {
        return isDetached && organizer != nil && !organizer!.isCurrentUser
    }

}
