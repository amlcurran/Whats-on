import Foundation
import Core

extension Date {

    func timeOfDay(isBetween borderStart: TimeOfDay, and borderEnd: TimeOfDay, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .day], from: self)
        if components.hour != nil {
            return isAfter(borderStart, in: calendar) && isBefore(borderEnd, in: calendar)
        }
        return false
    }

    func timeOfDay(isBetween borderStart: TimeOfDay, and borderEnd: TimeOfDay, onSameDayAs otherDate: Date, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .minute, .day], from: self)
        if components.hour != nil {
            return isAfter(borderStart, in: calendar) && isBefore(borderEnd, in: calendar) ||
                isBefore(borderEnd, in: calendar) && otherDate.startOfDay(in: calendar)! > self.startOfDay(in: calendar)!
        }
        return false
    }

    func isBefore(_ timeOfDay: TimeOfDay, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .minute, .day], from: self)
        if let hour = components.hour {
            if hour == timeOfDay.hours, let minute = components.minute {
                return minute <= timeOfDay.minutes
            }
            return hour <= timeOfDay.hours
        }
        return false
    }

    func isAfter(_ timeOfDay: TimeOfDay, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .minute, .day], from: self)
        if let hour = components.hour {
            if hour == timeOfDay.hours, let minute = components.minute {
                return minute > timeOfDay.minutes
            }
            return hour > timeOfDay.hours
        }
        return false
    }

    func startOfDay(in calendar: Calendar) -> Date? {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }

}

extension TimeOfDay {

    var minutes: Int {
        get {
            let hoursAsMinutes = hours * 60
            return Int(minutesInDay()) - hoursAsMinutes
        }
    }

}
