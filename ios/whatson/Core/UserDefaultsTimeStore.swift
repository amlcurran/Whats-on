import Foundation

public class UserDefaultsTimeStore {

    private let userDefaults: UserDefaults
    private let dateCalculator = NSDateCalculator.instance

    public init(userDefaults: UserDefaults = UserDefaults(suiteName: "group.uk.co.amlcurran.social")!) {
        self.userDefaults = userDefaults
    }

    public var startTimestamp: Timestamp {
        get {
            return dateCalculator.startOfToday().plusHours(hours: startTime)
        }
    }

    public var endTimestamp: Timestamp {
        get {
            return dateCalculator.startOfToday().plusHours(hours: endTime)
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
