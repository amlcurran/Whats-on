import Foundation

extension Date {

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