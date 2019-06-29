import UIKit
import Core

class NSDateTimeRepository: NSObject, TimeRepository {

    let calculator = NSDateCalculator.instance
    let timeStore = UserDefaultsTimeStore()

    var borderTimeStart: TimeOfDay {
        return TimeOfDay.fromHours(hours: timeStore.startTime)
    }

    var borderTimeEnd: TimeOfDay {
        return TimeOfDay.fromHours(hours: timeStore.endTime)
    }

}
