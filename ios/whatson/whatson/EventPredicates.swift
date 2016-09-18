import EventKit

@objc class EventPredicates: NSObject {
    
    static func compound(from predicates: [NSPredicate]) -> NSPredicate {
        return NSPredicate(block: { (element, bindings) -> Bool in
            return predicates.reduce(true, { (current, predicate) -> Bool in
                return current && predicate.evaluate(with: element)
            })
        })
    }
    
    @objc static func standardPredicates() -> NSPredicate {
        return compound(from: [ notAllDay(), isWithin(startHour: 18, endHour: 23, using: Calendar.autoupdatingCurrent) ])
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

private func isWithin(startHour: Int, endHour: Int, using calendar: Calendar) -> NSPredicate {
    return NSPredicate(block: { (element, bindings) -> Bool in
        if let event = element as? EKEvent {
            var startComponents = calendar.dateComponents([ .hour, .day ], from: event.startDate)
            var endComponents = calendar.dateComponents([ .hour, .day ], from: event.endDate)
            startComponents.timeZone = TimeZone.current
            endComponents.timeZone = TimeZone.current
            let endsBefore = endComponents.hour! <= startHour && endComponents.day! == startComponents.day!
            let beginsAfter = startComponents.hour! > endHour
            return !(endsBefore || beginsAfter)
        }
        return false
    })
}
