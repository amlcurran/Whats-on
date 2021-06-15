import UIKit

struct SlotStyle {
    let cellBackground: UIColor
    let selectedBackground: UIColor
    let mainText: UIColor
    let secondaryText: UIColor
    let borderColor: UIColor
    let borderWidth: CGFloat
    let borderDash: Border
    let isSecondaryTextShown: Bool

    static var empty: SlotStyle {
        return SlotStyle(cellBackground: .clear,
                         selectedBackground: .emptyOutline.withAlphaComponent(0.4),
                         mainText: .lightText,
                         secondaryText: .lightText,
                         borderColor: .emptyOutline,
                         borderWidth: 2.0,
                         borderDash: .dashed(width: 12),
                         isSecondaryTextShown: false)
    }

    static var full: SlotStyle {
        return SlotStyle(cellBackground: .surface,
                         selectedBackground: .surface.darkened(by: 0.1),
                         mainText: .secondary,
                         secondaryText: .lightText,
                         borderColor: .clear,
                         borderWidth: 0,
                         borderDash: .full,
                         isSecondaryTextShown: true)
    }

}
