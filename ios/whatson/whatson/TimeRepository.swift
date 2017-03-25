import UIKit

class TimeRepository: NSObject, SCTimeRepository {

    let calculator = NSDateCalculator.instance
    let timeStore = UserDefaultsTimeStore()

    func borderTimeStart() -> SCTimeOfDay {
        return SCTimeOfDay.fromHours(with: Int32(timeStore.startTime))
    }

    func borderTimeEnd() -> SCTimeOfDay {
        return SCTimeOfDay.fromHours(with: Int32(timeStore.endTime))
    }

}
