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
                    .hour: startTime
                ])!
        }
    }

    public var endTimestamp: Date {
        get {
            return Calendar.current.startOfToday
                .addingComponents([
                    .hour: endTime
                ])!
        }
    }

    @available(*, deprecated)
    public var startTime: Int {
        get {
            if let startTime = userDefaults.value(forKey: "startHour") as? Int {
                return startTime
            }
            return 17
        }
        set {
            userDefaults.set(newValue, forKey: "startHour")
        }
    }

    @available(*, deprecated)
    public var endTime: Int {
        get {
            if let endTime = userDefaults.value(forKey: "endHour") as? Int {
                return endTime
            }
            return 23
        }
        set {
            userDefaults.set(newValue, forKey: "endHour")
        }
    }

    public var borderTimeStart: TimeOfDay {
        return TimeOfDay.fromHours(hours: startTime)
    }

    public var borderTimeEnd: TimeOfDay {
        return TimeOfDay.fromHours(hours: endTime)
    }

}
