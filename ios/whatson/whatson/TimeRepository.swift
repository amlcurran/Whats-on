import UIKit

class TimeRepository: NSObject, SCTimeRepository {
    
    let calculator = NSDateCalculator()

    func borderTimeStart() -> SCTimeOfDay {
        return SCTimeOfDay.fromHours(with: 18)
    }
    
    func borderTimeEnd() -> SCTimeOfDay {
        return SCTimeOfDay.fromHours(with: 23)
    }
    
}
