import Foundation

public class NSDateCalculator: TimeCalculator {

    public static let instance: TimeCalculator = NSDateCalculator()

    private let calendar: Calendar

    private init() {
        calendar = Calendar.current
    }

    public func plusDays(days: Int, time: Timestamp) -> Timestamp {
        let newDate = add(days: days, to: time)
        return Timestamp(millis: Int(newDate.timeIntervalSince1970) * 1000, timeCalculator: self)
    }

    public func add(days: Int, to time: Timestamp) -> Date {
        var components = DateComponents()
        components.day = Int(days)
        return calendar.date(byAdding: components, to: date(from: time))!
    }

    public func getDays(time: Timestamp) -> Int {
        let difference = self.calendar.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: date(from: time))
        return difference.day!
    }

    public func plusHours(time: Timestamp, hours: Int) -> Timestamp {
        let newDate = add(hours: hours, to: date(from: time))
        return Timestamp(millis: Int(newDate.timeIntervalSince1970) * 1000, timeCalculator: self)
    }

    public func add(hours: Int, to time: Date) -> Date {
        var components = DateComponents()
        components.hour = Int(hours)
        return calendar.date(byAdding: components, to: time)!
    }

    public func startOfToday() -> Timestamp {
        return time(from: dateAtStartOfToday())
    }

    public func dateAtStartOfToday() -> Date {
        var components = NSCalendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSCalendar.current.date(from: components)!
    }

    public func date(from time: Timestamp) -> Date {
        return Date(timeIntervalSince1970: (Double(time.millis) / 1000.0))
    }

    public func time(from date: Date) -> Timestamp {
        return Timestamp(millis: Int(date.timeIntervalSince1970 * 1000), timeCalculator: self)
    }

}
