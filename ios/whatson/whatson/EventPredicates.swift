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
        let start = timeRepository.borderTimeStart()
        let end = timeRepository.borderTimeEnd()
        return event.startDate.timeOfDay(isBetween: start, and: end, onSameDayAs: event.endDate, in: calendar) ||
            event.endDate.timeOfDay(isBetween: start, and: end, in: calendar) ||
            (event.startDate.isBefore(start, in: calendar) && event.endDate.isAfter(end, in: calendar))
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

private extension Date {

    func timeOfDay(isBetween borderStart: SCTimeOfDay, and borderEnd: SCTimeOfDay, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .day], from: self)
        if let hour = components.hour {
            return borderStart.hours <= hour && borderEnd.hours > hour
        }
        return false
    }

    func timeOfDay(isBetween borderStart: SCTimeOfDay, and borderEnd: SCTimeOfDay, onSameDayAs otherDate: Date, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .day], from: self)
        if let hour = components.hour {
            return borderStart.hours <= hour && borderEnd.hours > hour ||
                borderEnd.hours > hour && otherDate.startOfDay(in: calendar)! > self.startOfDay(in: calendar)!
        }
        return false
    }

    func isBefore(_ timeOfDay: SCTimeOfDay, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .day], from: self)
        if let hour = components.hour {
            return hour <= timeOfDay.hours
        }
        return false
    }

    func isAfter(_ timeOfDay: SCTimeOfDay, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .day], from: self)
        if let hour = components.hour {
            return hour > timeOfDay.hours
        }
        return false
    }

    func startOfDay(in calendar: Calendar) -> Date? {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }

}

extension SCTimeOfDay {

    var hours: Int {
        get {
            return Int(hoursInDay())
        }
    }

}
