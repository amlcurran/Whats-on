import UIKit
import SwiftUI

private let textColors: [LabelStyle: UIColor] = [
        .cta: .accent,
        .lower: .lightText,
        .header: .secondary,
        .selectableTime: .secondary
]
private let fonts: [LabelStyle: UIFont] = [
        .cta: .systemFont(ofSize: 14, weight: UIFont.Weight.medium),
        .lower: .systemFont(ofSize: 14, weight: UIFont.Weight.medium),
        .header: .systemFont(ofSize: 16, weight: UIFont.Weight.semibold),
        .selectableTime: .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
]

enum LabelStyle {
    case cta
    case lower
    case header
    case selectableTime
}

extension UILabel {

    func set(style: LabelStyle) {
        textColor = textColors[style]
        font = fonts[style]
    }

}

struct LabelStyleModifier: ViewModifier {
    
    let style: LabelStyle
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(uiColor: textColors[style]!))
            .font(Font(fonts[style]!))
    }
    
}

extension View {
    
    func labelStyle(_ style: LabelStyle) -> some View {
        self.modifier(LabelStyleModifier(style: style))
    }
    
}

extension UIButton {

    func set(style: LabelStyle) {
        setTitleColor(textColors[style], for: .normal)
        setTitleColor(textColors[style]?.darkened(by: 0.2), for: .highlighted)
        titleLabel?.font = fonts[style]
    }

}
