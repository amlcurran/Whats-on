import Foundation
import UIKit

class TimeLabel: UIView {

    private var label = UILabel()

    var selected = false {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                if (self.selected) {
                    self.backgroundColor = .accent
                } else {
                    self.backgroundColor = .clear
                }
            })
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        _ = label.surrounded(by: self, inset: 4)
        layer.cornerRadius = 3
        layer.borderWidth = 2
        layer.borderColor = UIColor.accent.darken(by: 0.2).cgColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

}
