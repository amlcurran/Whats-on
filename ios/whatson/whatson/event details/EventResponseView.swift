import Foundation
import UIKit

class EventResponseView: UIStackView {

    let acceptButton = UIButton()
    let maybeButton = UIButton()
    let declineButton = UIButton()
    let selectedColor = UIColor.accent

    private weak var delegate: EventResponseViewDelegate?

    init(delegate: EventResponseViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.alignment = .center
        acceptButton.setTitle("Accept", for: .normal)
        self.addArrangedSubview(acceptButton)
        acceptButton.addTarget(self, action: #selector(statusTapped), for: .touchUpInside)
        maybeButton.setTitle("Maybe", for: .normal)
        self.addArrangedSubview(maybeButton)
        maybeButton.addTarget(self, action: #selector(statusTapped), for: .touchUpInside)
        declineButton.setTitle("Decline", for: .normal)
        self.addArrangedSubview(declineButton)
        declineButton.addTarget(self, action: #selector(statusTapped), for: .touchUpInside)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func statusTapped(button: UIButton) {
        if button == acceptButton {
            set(.accepted)
            delegate?.changeResponse(to: .accepted)
        } else if button == maybeButton {
            set(.maybe)
            delegate?.changeResponse(to: .maybe)
        } else {
            set(.declined)
            delegate?.changeResponse(to: .declined)
        }
    }

    func set(_ response: EventResponse) {
        switch response {
        case .accepted:
            acceptButton.backgroundColor = selectedColor
            declineButton.backgroundColor = .clear
            maybeButton.backgroundColor = .clear
        case .declined:
            acceptButton.backgroundColor = .clear
            declineButton.backgroundColor = selectedColor
            maybeButton.backgroundColor = .clear
        case .maybe:
            acceptButton.backgroundColor = .clear
            declineButton.backgroundColor = .clear
            maybeButton.backgroundColor = selectedColor
        case .none:
            acceptButton.backgroundColor = .clear
            declineButton.backgroundColor = .clear
            maybeButton.backgroundColor = .clear
        }
    }

}

protocol EventResponseViewDelegate: class {
    func changeResponse(to state: EventResponse)
}
