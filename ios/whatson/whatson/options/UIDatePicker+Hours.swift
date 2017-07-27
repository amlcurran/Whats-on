import Foundation
import UIKit

extension UIDatePicker {

    var hour: Int? {
        get {
            return Calendar.current.dateComponents([.hour], from: date).hour
        }
    }

    func set(hour: Int, limitedAfter lowerLimit: Int) {
        var components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
        components.hour = hour
        components.minute = 0
        date = Calendar.current.date(from: components)!

        components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
        components.hour = lowerLimit
        components.minute = 0
        minimumDate = Calendar.current.date(from: components)
        maximumDate = nil
    }

    func set(hour: Int, limitedBefore upperLimit: Int) {
        var components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
        components.hour = hour
        components.minute = 0
        date = Calendar.current.date(from: components)!

        components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
        components.hour = upperLimit
        components.minute = 0
        minimumDate = nil
        maximumDate = Calendar.current.date(from: components)
    }

    var hasMinutes: Bool {
        let components = Calendar.current.dateComponents([.minute], from: date)
        return components.minute.or(0) != 0
    }

    func removeMinutes() {
        var components = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        components.minute = 0
        date = Calendar.current.date(from: components)!
    }

}
