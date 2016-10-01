import UIKit

class TimeRepository: NSObject, SCTimeRepository {
    
    let calculator = NSDateCalculator()

    func borderTimeStart() -> SCTimeOfDay {
        return SCTimeOfDay.fromHours(with: 18)
    }
    
    func borderTimeEnd() -> SCTimeOfDay {
        return SCTimeOfDay.fromHours(with: 23)
    }
    
    func startOfToday() -> SCTimestamp {
        var components = NSCalendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        let newDate = NSCalendar.current.date(from: components)!
        return calculator.time(newDate as NSDate)
    }
    
}
