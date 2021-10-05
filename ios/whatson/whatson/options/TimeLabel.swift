import Foundation
import UIKit

private let dateFormatter = DateFormatter.shortTime

class TimeLabel: UIView {

    private let label = UILabel()
    private var gestureRecogniser: UITapGestureRecognizer?

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
        addSubview(label)
        label.constrain(toSuperview: .leading, .trailing, .bottom, .top, insetBy: 4)
        layer.cornerRadius = 3
        layer.borderWidth = 2
        layer.borderColor = UIColor.accent.darkened(by: 0.2).cgColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    @objc private func tapped() {
        tapClosure?()
    }

    var text: Date = Date() {
        didSet {
            label.text = dateFormatter.string(from: text)
        }
    }

}
