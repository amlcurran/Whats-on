import Foundation

public class NSDateCalculator : NSObject, SCTimeCalculator {
    
    static var instance: NSDateCalculator = {
       return NSDateCalculator()
    }()
    
    let calendar: Calendar
    
    private override init() {
        calendar = Calendar.current
        super.init()
    }
    
    func now() -> SCTimestamp {
        let millis = jlong(Date().timeIntervalSince1970 * 1000);
        return SCTimestamp(long: millis, with: self);
    }
    
    @objc public func plusDays(with days: jint, with time: SCTimestamp!) -> SCTimestamp {
        var components = DateComponents();
        components.day = Int(days);
        let timeAsDate = date(time);
        let newDate = calendar.date(byAdding: components, to: timeAsDate);
        return SCTimestamp(long: jlong(newDate!.timeIntervalSince1970 * 1000), with: self);
    }
    
    @objc public func getDaysWith(_ time: SCTimestamp!) -> jint {
        let difference = self.calendar.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: date(time));
        return jint(difference.day!);
    }
    
    @objc public func plusHours(with time: SCTimestamp!, with hours: jint) -> SCTimestamp {
        var components = DateComponents();
        components.hour = Int(hours);
        let timeAsDate = date(time);
        let newDate = calendar.date(byAdding: components, to: timeAsDate);
        return SCTimestamp(long: jlong(newDate!.timeIntervalSince1970 * 1000), with: self);
    }
    
    @objc public func startOfToday() -> SCTimestamp {
        var components = NSCalendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: Date())
        components.hour = 0
        components.minute = 0
        components.second = 0
        let newDate = NSCalendar.current.date(from: components)!
        return time(newDate as NSDate)
    }
    
    internal func date(_ time: SCTimestamp) -> Date {
        return Date(timeIntervalSince1970: (Double(time.getMillis()) / 1000.0));
    }
    
    internal func time(_ date: NSDate) -> SCTimestamp {
        return SCTimestamp(long: jlong(date.timeIntervalSince1970 * 1000), with: self);
    }
    
}
