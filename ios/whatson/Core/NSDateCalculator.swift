import Foundation

extension Date {

    func daysSinceEpoch(in calendar: Calendar = .current) -> Int {
        let difference = calendar.dateComponents(
            [.day],
            from: Date(timeIntervalSince1970: 0),
            to: self
        )
        return difference.day!
    }

    public func settingComponents(_ components: [Calendar.Component: Int], in calendar: Calendar = Calendar.current) -> Date? {
        calendar.date(bySetting: components, of: self)
    }

    public func addingComponents(_ components: [Calendar.Component: Int], in calendar: Calendar = Calendar.current) -> Date? {
        calendar.date(byAdding: components, to: self)
    }

}

extension Calendar {

    public func date(bySetting components: [Calendar.Component: Int], of date: Date) -> Date? {
        return components.reduce(Optional.some(date)) { (date: Date?, kvPair: (key: Calendar.Component, value: Int)) in
            let (component, value) = kvPair
            return date.flatMap { self.date(bySetting: component, value: value, of: $0) }
        }
    }

    public func date(byAdding components: [Calendar.Component: Int], to date: Date) -> Date? {
        return components.reduce(Optional.some(date)) { (date: Date?, kvPair: (key: Calendar.Component, value: Int)) in
            let (component, value) = kvPair
            return date.flatMap { self.date(byAdding: component, value: value, to: $0) }
        }
    }

    public var startOfToday: Date {
        return date(bySetting: [
            .hour: 0,
            .minute: 0,
            .second: 1
        ], of: Date())!
    }

}
