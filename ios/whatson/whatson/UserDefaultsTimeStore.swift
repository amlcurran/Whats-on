import Foundation

class UserDefaultsTimeStore {

    private let userDefaults: UserDefaults
    private let dateCalculator = NSDateCalculator.instance

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var startTimestamp: SCTimestamp {
        get {
            return dateCalculator.startOfToday().plusHours(with: Int32(startTime))
        }
    }

    var endTimestamp: SCTimestamp {
        get {
            return dateCalculator.startOfToday().plusHours(with: Int32(endTime))
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
