import Foundation

public class UserDefaultsTimeStore {

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

}
