import UIKit

class TimeRepository: NSObject, SCTimeRepository {
    
    let calculator = NSDateCalculator()

    func borderTimeStart() -> SCTimeOfDay {
        let hours = UserDefaults.standard.string(forKey: "startHour").flatMap({ Int32($0) })
        return SCTimeOfDay.fromHours(with: hours.or(18))
    }
    
    func borderTimeEnd() -> SCTimeOfDay {
        let hours = UserDefaults.standard.string(forKey: "endHour").flatMap({ Int32($0) })
        return SCTimeOfDay.fromHours(with: hours.or(23))
    }
    
}
