import Foundation
import Core

public class NSDateCalculator: TimeCalculator {

    static let instance = NSDateCalculator()

    private let calendar: Calendar

    private init() {
        calendar = Calendar.current
    }

    public func plusDays(days: Int, time: Timestamp) -> Timestamp {
        var components = DateComponents()
        components.day = Int(days)
        let newDate = calendar.date(byAdding: components, to: date(from: time))
        return Timestamp(millis: Int(newDate!.timeIntervalSince1970) * 1000, timeCalculator: self)
    }

    public func getDays(time: Timestamp) -> Int {
        let difference = self.calendar.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: date(from: time))
        return difference.day!
    }

    public func plusHours(time: Timestamp, hours: Int) -> Timestamp {
        var components = DateComponents()
        components.hour = Int(hours)
        let newDate = calendar.date(byAdding: components, to: date(from: time))
        return Timestamp(millis: Int(newDate!.timeIntervalSince1970) * 1000, timeCalculator: self)
    }

    public func startOfToday() -> Timestamp {
        var components = NSCalendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        let newDate = NSCalendar.current.date(from: components)!
        return time(from: newDate)
    }

    internal func date(from time: Timestamp) -> Date {
        return Date(timeIntervalSince1970: (Double(time.millis) / 1000.0))
    }

    internal func time(from date: Date) -> Timestamp {
        return Timestamp(millis: Int(date.timeIntervalSince1970 * 1000), timeCalculator: self)
    }

}
