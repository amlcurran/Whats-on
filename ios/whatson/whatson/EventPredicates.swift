import EventKit

@objc class EventPredicates: NSObject {
    
    static func compound(from predicates: [Predicate]) -> Predicate {
        return Predicate(block: { (element, bindings) -> Bool in
            return predicates.reduce(true, combine: { (current, predicate) -> Bool in
                return current && predicate.evaluate(with: element)
            })
        })
    }
    
    @objc static func standardPredicates() -> Predicate {
        return compound(from: [ notAllDay(), isWithin(startHour: 18, endHour: 23, using: Calendar.autoupdatingCurrent) ])
    }

}

private func notAllDay() -> Predicate {
    return Predicate(block: { (element, bindings) -> Bool in
        if let event = element as? EKEvent {
            return !event.isAllDay
        }
        return false
    })
}

private func isWithin(startHour: Int, endHour: Int, using calendar: Calendar) -> Predicate {
    return Predicate(block: { (element, bindings) -> Bool in
        if let event = element as? EKEvent {
            var startComponents = calendar.components([ .hour, .day ], from: event.startDate)
            var endComponents = calendar.components([ .hour, .day ], from: event.endDate)
            startComponents.timeZone = TimeZone.default
            endComponents.timeZone = TimeZone.default
            let endsBefore = endComponents.hour <= startHour && endComponents.day == startComponents.day
            let beginsAfter = startComponents.hour > endHour
            return !(endsBefore || beginsAfter)
        }
        return false
    })
}
