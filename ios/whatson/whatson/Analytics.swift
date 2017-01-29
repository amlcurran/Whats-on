import Foundation
import FirebaseAnalytics

struct Analytics {

    func sendEvent(named name: String, withParameters parameters: [String: String] = [:]) {
        FIRAnalytics.logEvent(withName: name, parameters: parameters.convertValuesToNSString())
    }

}

extension Collection where Iterator.Element == (key: String, value: String) {

    func convertValuesToNSString() -> [String: NSString] {
        var dictionary: [String: NSString] = [:]
        for pair in self {
            dictionary[pair.key] = pair.value as NSString
        }
        return dictionary
    }

}
