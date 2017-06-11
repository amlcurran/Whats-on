import EventKit

struct EventPredicates {

    private let timeRepository: SCTimeRepository

    init(timeRepository: SCTimeRepository) {
        self.timeRepository = timeRepository
    }

    var defaults: EventPredicate {
        return compound(from: notDeclinedOrCancelled(),
                        notAllDay(),
                        isWithinBorder(timeRepository: timeRepository, using: .autoupdatingCurrent))
    }

}

typealias EventPredicate = (EKEvent) -> Bool

func compound(from predicates: EventPredicate...) -> EventPredicate {
    return { event in
        predicates.reduce(true, { (current: Bool, predicate: EventPredicate) in
            return current && predicate(event)
        })
    }
}

private func notDeclinedOrCancelled() -> EventPredicate {
    return { event in
        guard let attendees = event.attendees else {
            return true
        }
        if let mainUser = attendees.mainUser {
            return mainUser.participantStatus == .accepted
        }
        return false
    }
}

extension Array where Element == EKParticipant {

    var mainUser: EKParticipant? {
        return filter({ $0.isCurrentUser }).first
    }

}

private func notAllDay() -> EventPredicate {
    return { event in
        return !event.isAllDay
    }
}

private func isWithinBorder(timeRepository: SCTimeRepository, using calendar: Calendar) -> EventPredicate {
    return { event in
        let start = timeRepository.borderTimeStart()
        let end = timeRepository.borderTimeEnd()
        return event.startDate.timeOfDay(isBetween: start, and: end, onSameDayAs: event.endDate, in: calendar) ||
            event.endDate.timeOfDay(isBetween: start, and: end, in: calendar) ||
            (event.startDate.isBefore(start, in: calendar) && event.endDate.isAfter(end, in: calendar))
    }
}

extension SCTimeOfDay {

    var hours: Int {
        get {
            return Int(hoursInDay())
        }
    }

}
