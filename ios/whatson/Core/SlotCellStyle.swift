import UIKit
import SwiftUI

struct SlotModifier: ViewModifier {

    enum Style {
        case empty
        case full
        case unanswered
    }
    
    let style: Style

    func body(content: Content) -> some View {
        ZStack {
            if style != .full {
                ContainerRelativeShape()
                    .stroke(style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [8], dashPhase: 0))
                    .foregroundColor(Color("emptyOutline"))
            }
            if style != .empty {
                ContainerRelativeShape()
                    .foregroundColor(Color("surface"))
            }
            content
        }
    }

}

extension View {
    
    func slot(style: SlotModifier.Style) -> some View {
        self
            .modifier(SlotModifier(style: style))
    }
    
}

enum Border {
    case full
    case dashed(width: Float)
}

extension CACornerMask {

    static var all: CACornerMask {
        return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}

struct SlotModifier_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(spacing: 8) {
            Text("Empty")
                .slot(style: .empty)
            Text("Full")
                .slot(style: .full)
            Text("Unanswered")
                .slot(style: .unanswered)
        }
        .padding()
        .background(Color("windowBackground"))
    }
    
}
