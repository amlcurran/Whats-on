import Core

extension Timestamp {

    static var now: Timestamp {
        let millis = Date().timeIntervalSince1970 * 1000
        return Timestamp(millis: Int(millis), timeCalculator: NSDateCalculator.instance)
    }

}
