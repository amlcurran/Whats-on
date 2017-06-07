import Foundation

extension DateFormatter {

    static var shortTime: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            return formatter
        }
    }

    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }

}
