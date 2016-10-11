import UIKit

private let textColors: [LabelStyle : UIColor] = [
    .cta : .accent,
    .lower : .lightText,
    .header : .secondary
]
private let fonts: [LabelStyle : UIFont] = [
    .cta : .systemFont(ofSize: 14, weight: UIFontWeightMedium),
    .lower : .systemFont(ofSize: 14, weight: UIFontWeightMedium),
    .header : .systemFont(ofSize: 16, weight: UIFontWeightSemibold)
]

enum LabelStyle {
    case cta
    case lower
    case header
}

extension UILabel {
    
    func set(style: LabelStyle) {
        textColor = textColors[style]
        font = fonts[style]
        
    }
    
}

extension UIButton {
    
    func set(style: LabelStyle) {
        setTitleColor(textColors[style], for: .normal)
        setTitleColor(textColors[style]?.darken(by: 0.2), for: .highlighted)
        titleLabel?.font = fonts[style]
    }
    
}
