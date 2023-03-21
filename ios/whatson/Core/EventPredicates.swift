import EventKit

struct EventPredicates {

    let timeRepository: BorderTimeRepository
    let eventPreferences: CalendarPreferenceStore

    var defaults: EventPredicate {
        return compound(from: notDeclinedOrCancelled(),
                        notAllDay(),
                        notMultiDay(),
                        notYetConfirmed(eventPreferences: eventPreferences),
                        isWithinBorder(timeRepository: timeRepository, using: .autoupdatingCurrent))
    }

}

typealias EventPredicate = ((EKEvent) -> Bool, String)

func compound(from predicates: EventPredicate...) -> EventPredicate {
    return ({ event in
        print("\(event.title ?? "Unnamed event"):")
        return predicates.reduce(true, { (current: Bool, predicate: EventPredicate) in
            let thisTest = predicate.0(event)
            print("- \(predicate.1): \(thisTest)")
            return current && thisTest
        })
    }, "compound")
}

private func notDeclinedOrCancelled() -> EventPredicate {
    return ({ event in
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
    }, "declined or cancelled")
}

private func notYetConfirmed(eventPreferences: CalendarPreferenceStore) -> EventPredicate {
    return ({ event in
        guard let attendees = event.attendees else {
            return true
        }
        if let mainUser = attendees.mainUser, mainUser.participantStatus == .pending {
            return eventPreferences.showUnansweredEvents
        }
        return true
    }, "notYetConfirmed")
}

extension Array where Element == EKParticipant {

    var mainUser: EKParticipant? {
        return filter({ $0.isCurrentUser }).first
    }

}

private func notAllDay() -> EventPredicate {
    return ({ event in
        return !event.isAllDay
    }, "notAllDay")
}

private func notMultiDay() -> EventPredicate {
    return ({ event in
        if #available(iOS 13.0, *) {
            return abs(event.startDate.distance(to: event.endDate)) < 24 * 60 * 60
        } else {
            return false
        }
    }, "notMultiDay")
}

private func isWithinBorder(timeRepository: BorderTimeRepository, using calendar: Calendar) -> EventPredicate {
    return ({ event in
        let start = timeRepository.borderTimeStart
        let end = timeRepository.borderTimeEnd
        let test = event.startDate.timeOfDay(isBetween: start, and: end, onSameDayAs: event.endDate, in: calendar) ||
        event.endDate.timeOfDay(isBetween: start, and: end, in: calendar) ||
        (event.startDate.isBefore(start, in: calendar) && event.endDate.isAfter(end, in: calendar))
        return test
    }, "withinBorders")
}

extension TimeOfDay {

    var hours: Int {
        get {
            return Int(hoursInDay())
        }
    }

}
