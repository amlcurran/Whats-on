import Foundation

public class NSDateCalculator: TimeCalculator {

    public static let instance: TimeCalculator = NSDateCalculator()

    private let calendar: Calendar

    private init() {
        calendar = Calendar.current
    }

    public func add(days: Int, to time: Date) -> Date {
        var components = DateComponents()
        components.day = Int(days)
        return calendar.date(byAdding: components, to: time)!
    }

    public func add(hours: Int, to time: Date) -> Date {
        var components = DateComponents()
        components.hour = Int(hours)
        return calendar.date(byAdding: components, to: time)!
    }

    public func dateAtStartOfToday() -> Date {
        var components = NSCalendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSCalendar.current.date(from: components)!
    }

}

extension Date {

    func daysSinceEpoch(in calendar: Calendar = .current) -> Int {
        let difference = calendar.dateComponents(
            [.day],
            from: Date(timeIntervalSince1970: 0),
            to: self
        )
        return difference.day!
    }

}
