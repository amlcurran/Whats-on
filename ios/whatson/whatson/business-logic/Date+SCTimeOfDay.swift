import Foundation

extension Date {

    func timeOfDay(isBetween borderStart: SCTimeOfDay, and borderEnd: SCTimeOfDay, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .day], from: self)
        if let _ = components.hour {
            return isAfter(borderStart, in: calendar) && isBefore(borderEnd, in: calendar)
        }
        return false
    }

    func timeOfDay(isBetween borderStart: SCTimeOfDay, and borderEnd: SCTimeOfDay, onSameDayAs otherDate: Date, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .minute, .day], from: self)
        if let _ = components.hour {
            return isAfter(borderStart, in: calendar) && isBefore(borderEnd, in: calendar) ||
                isBefore(borderEnd, in: calendar) && otherDate.startOfDay(in: calendar)! > self.startOfDay(in: calendar)!
        }
        return false
    }

    func isBefore(_ timeOfDay: SCTimeOfDay, in calendar: Calendar) -> Bool {
        let components = calendar.dateComponents([.hour, .minute, .day], from: self)
        if let hour = components.hour {
            if hour == timeOfDay.hours, let minute = components.minute {
                return minute <= timeOfDay.minutes
            }
            return hour <= timeOfDay.hours
        }
        return false
    }

    func isAfter(_ timeOfDay: SCTimeOfDay, in calendar: Calendar) -> Bool {
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

extension SCTimeOfDay {

    var minutes: Int {
        get {
            let hoursAsMinutes = hours * 60
            return Int(minutesInDay()) - hoursAsMinutes
        }
    }

}
