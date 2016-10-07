import Foundation

extension SCTimestamp {
    
    static var now: SCTimestamp {
        let millis = jlong(Date().timeIntervalSince1970 * 1000)
        return SCTimestamp(long: millis, with: NSDateCalculator.instance)
    }
    
}
