import Foundation

public class UserDefaultsTimeStore: BorderTimeRepository {

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = UserDefaults(suiteName: "group.uk.co.amlcurran.social")!) {
        self.userDefaults = userDefaults
    }

    public var startTimestamp: Date {
        get {
            Calendar.current.startOfToday
                .addingComponents([
                    .hour: startTime.hours,
                    .minute: startTime.minutes
                ])!
        }
    }

    public var endTimestamp: Date {
        get {
            return Calendar.current.startOfToday
                .addingComponents([
                    .hour: endTime.hours,
                    .minute: endTime.minutes
                ])!
        }
    }

    public var startTime: (hours: Int, minutes: Int) {
        get {
            return (userDefaults[asInt: "startHour"] ?? 17,
                    userDefaults[asInt: "startMinutes"] ?? 0)
        }
        set {
            userDefaults.set(newValue.hours, forKey: "startHour")
            userDefaults.set(newValue.minutes, forKey: "startMinutes")
        }
    }

    public var endTime: (hours: Int, minutes: Int) {
        get {
            (userDefaults[asInt: "endHour"] ?? 23,
             userDefaults[asInt: "endMinutes"] ?? 0)
        }
        set {
            userDefaults.set(newValue.hours, forKey: "endHour")
            userDefaults.set(newValue.minutes, forKey: "endMinutes")
        }
    }

    public var borderTimeStart: TimeOfDay {
        return TimeOfDay.fromHours(hours: startTime.hours, andMinutes: startTime.minutes)
    }

    public var borderTimeEnd: TimeOfDay {
        return TimeOfDay.fromHours(hours: endTime.hours, andMinutes: endTime.minutes)
    }

}

extension UserDefaults {

    subscript(asInt key: String) -> Int? {
        return self.value(forKey: key) as? Int
    }

}
