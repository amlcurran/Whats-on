import EventKit

struct EventPredicates {

    private let timeRepository: BorderTimeRepository

    init(timeRepository: BorderTimeRepository) {
        self.timeRepository = timeRepository
    }

    var defaults: EventPredicate {
        return compound(from: notDeclinedOrCancelled(),
                        notAllDay(),
                        notMultiDay(),
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
        if let organiser = event.organizer {
            return organiser.isCurrentUser
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

private func notMultiDay() -> EventPredicate {
    return { event in
        if #available(iOS 13.0, *) {
            return abs(event.startDate.distance(to: event.endDate)) < 24 * 60 * 60
        } else {
            return false
        }
    }
}

private func isWithinBorder(timeRepository: BorderTimeRepository, using calendar: Calendar) -> EventPredicate {
    return { event in
        let start = timeRepository.borderTimeStart
        let end = timeRepository.borderTimeEnd
        let test = event.startDate.timeOfDay(isBetween: start, and: end, onSameDayAs: event.endDate, in: calendar) ||
        event.endDate.timeOfDay(isBetween: start, and: end, in: calendar) ||
        (event.startDate.isBefore(start, in: calendar) && event.endDate.isAfter(end, in: calendar))
        return test
    }
}

extension TimeOfDay {

    var hours: Int {
        get {
            return Int(hoursInDay())
        }
    }

}
