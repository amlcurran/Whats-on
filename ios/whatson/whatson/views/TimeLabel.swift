import Foundation
import UIKit

class TimeLabel: UIView {

    private let label = UILabel()
    private var gestureRecogniser: UITapGestureRecognizer? = nil
    var tapClosure: (() -> Void)? = nil {
        didSet {
            if let previousRecognizer = gestureRecogniser {
                removeGestureRecognizer(previousRecognizer)
            }
            let newRecogniser = UITapGestureRecognizer(target: self, action: #selector(tapped))
            addGestureRecognizer(newRecogniser)
            gestureRecogniser = newRecogniser
        }
    }

    var selected = false {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                if self.selected {
                    self.backgroundColor = UIColor.accent.withAlphaComponent(0.6)
                } else {
                    self.backgroundColor = .clear
                }
            })
        }
    }

    init() {
        super.init(frame: .zero)
        _ = label.surrounded(by: self, inset: 4)
        layer.cornerRadius = 3
        layer.borderWidth = 2
        layer.borderColor = UIColor.accent.darken(by: 0.2).cgColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    @objc private func tapped() {
        tapClosure?()
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
