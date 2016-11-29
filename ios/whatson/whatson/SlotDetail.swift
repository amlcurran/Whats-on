import Foundation

enum SlotDetail {
    case low
    case mid
    case full

    var isSecondaryTextShown: Bool {
        return self != .low
    }

}
