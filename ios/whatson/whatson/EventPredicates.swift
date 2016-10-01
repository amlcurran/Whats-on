import EventKit

struct EventPredicates {
    
    static func compound(from predicates: [NSPredicate]) -> NSPredicate {
        return NSPredicate(block: { (element, bindings) -> Bool in
            return predicates.reduce(true, { (current, predicate) -> Bool in
                return current && predicate.evaluate(with: element)
            })
        })
    }
    
    static func standardPredicates() -> NSPredicate {
        let timeRepository = TimeRepository()
        return compound(from: [ notAllDay(), isWithinBorder(timeRepository: timeRepository, using: Calendar.autoupdatingCurrent) ])
    }

}

private func notAllDay() -> NSPredicate {
    return NSPredicate(block: { (element, bindings) -> Bool in
        if let event = element as? EKEvent {
            return !event.isAllDay
        }
        return false
    })
}

private func isWithinBorder(timeRepository: TimeRepository, using calendar: Calendar) -> NSPredicate {
    return NSPredicate(block: { (element, bindings) -> Bool in
        if let event = element as? EKEvent {
            var startComponents = calendar.dateComponents([ .hour, .day ], from: event.startDate)
            var endComponents = calendar.dateComponents([ .hour, .day ], from: event.endDate)
            startComponents.timeZone = TimeZone.current
            endComponents.timeZone = TimeZone.current
            let endHour = endComponents.hour!
            let startHour = startComponents.hour!
            let endsBefore = endHour <= Int(timeRepository.borderTimeStart().toHours()) && endComponents.day! == startComponents.day!
            let beginsAfter = startHour > Int(timeRepository.borderTimeEnd().toHours())
            return !(endsBefore || beginsAfter)
        }
        return false
    })
}
