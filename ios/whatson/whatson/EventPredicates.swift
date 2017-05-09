import EventKit

struct EventPredicates {

    let timeRepository: SCTimeRepository

    func standard() -> NSPredicate {
        return NSPredicate(compoundFrom: [
                notAllDay(),
                isWithinBorder(timeRepository: timeRepository, using: Calendar.autoupdatingCurrent),
                notDeclinedOrCancelled()
        ])
    }

}

extension NSPredicate {

    convenience init(compoundFrom predicates: [NSPredicate]) {
        self.init(block: { (element, _) -> Bool in
            return predicates.reduce(true, { (current, predicate) -> Bool in
                return current && predicate.evaluate(with: element)
            })
        })
    }

}

private func notDeclinedOrCancelled() -> NSPredicate {
    return NSPredicate(eventBlock: { event in
        return event.status != EKEventStatus.canceled
    })
}

private func notAllDay() -> NSPredicate {
    return NSPredicate(eventBlock: { event in
        return !event.isAllDay
    })
}

private func isWithinBorder(timeRepository: SCTimeRepository, using calendar: Calendar) -> NSPredicate {
    return NSPredicate(eventBlock: { event in
        let endsBefore = timeRepository.borderTimeStart().isBefore(event.startDate, inSameDayAs: event.endDate, in: calendar)
        let beginsAfter = timeRepository.borderTimeEnd().isAfter(event.endDate, in: calendar)
        return !(endsBefore || beginsAfter)
    })
}

private extension NSPredicate {

    convenience init(eventBlock: @escaping ((EKEvent) -> Bool)) {
        self.init(block: { element, _ in
            if let event = element as? EKEvent {
                return eventBlock(event)
            }
            return false
        })
    }

}

private extension SCTimeOfDay {

    func isBefore(_ date: Date, inSameDayAs otherDate: Date, in calendar: Calendar) -> Bool {
        var startComponents = calendar.dateComponents([.hour, .day], from: date)
        var endComponents = calendar.dateComponents([.hour, .day], from: otherDate)
        startComponents.timeZone = TimeZone.current
        endComponents.timeZone = TimeZone.current
        return isBefore(endComponents, inSameDayAs: startComponents)
    }

    func isAfter(_ date: Date, in calendar: Calendar) -> Bool {
        var startComponents = calendar.dateComponents([.hour, .day], from: date)
        startComponents.timeZone = TimeZone.current
        return isAfter(startComponents)
    }

    func isBefore(_ components: DateComponents, inSameDayAs otherComponents: DateComponents) -> Bool {
        return components.hour! <= Int(toHours()) && components.day! == otherComponents.day!
    }

    func isAfter(_ components: DateComponents) -> Bool {
        return components.hour! > Int(toHours())
    }
}
