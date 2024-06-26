import UIKit

public class NSDateTimeRepository: NSObject, BorderTimeRepository {

    let calculator = NSDateCalculator.instance
    let timeStore = UserDefaultsTimeStore()

    public var borderTimeStart: TimeOfDay {
        return TimeOfDay.fromHours(hours: timeStore.startTime)
    }

    public var borderTimeEnd: TimeOfDay {
        return TimeOfDay.fromHours(hours: timeStore.endTime)
    }

}
