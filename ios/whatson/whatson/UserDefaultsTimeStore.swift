import Foundation
import Core

class UserDefaultsTimeStore {

    private let userDefaults: UserDefaults
    private let dateCalculator = NSDateCalculator.instance

    init(userDefaults: UserDefaults = UserDefaults(suiteName: "group.uk.co.amlcurran.social")!) {
        self.userDefaults = userDefaults
    }

    var startTimestamp: Timestamp {
        get {
            return dateCalculator.startOfToday().plusHours(hours: startTime)
        }
    }

    var endTimestamp: Timestamp {
        get {
            return dateCalculator.startOfToday().plusHours(hours: endTime)
        }
    }

    var startTime: Int {
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

    var endTime: Int {
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
