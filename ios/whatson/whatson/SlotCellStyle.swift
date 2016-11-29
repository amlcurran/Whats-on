import UIKit

private let backgrounds: [SlotCellStyle: UIColor] = [.empty: .clear, .full: .white]
private let mainTexts: [SlotCellStyle: UIColor] = [.empty: .lightText, .full: .secondary]
private let secondaryTexts: [SlotCellStyle: UIColor] = [.empty: .lightText, .full: .lightText]
private let borderColors: [SlotCellStyle: UIColor] = [.empty: .emptyOutline, .full: .clear]

enum SlotCellStyle {
    case empty
    case full

    var cellBackground: UIColor {
        return backgrounds[self].or(.white)
    }

    var mainText: UIColor {
        return mainTexts[self].or(.secondary)
    }

    var secondaryText: UIColor {
        return secondaryTexts[self].or(.lightText)
    }

    var borderColor: UIColor {
        return borderColors[self].or(.clear)
    }

    var borderWidth: CGFloat {
        return self == .empty ? 2 : 0
    }

    var borderDash: Border {
        return self == .empty ? .dashed(width: 12) : .full
    }

    var isSecondaryTextShown: Bool {
        return self == .full
    }
}
