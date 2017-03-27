import UIKit

class FailedAccessView: UIView {

    init() {
        super.init(frame: .zero)
        let label = UILabel()
        label.set(style: .lower)
        label.numberOfLines = 0
        addSubview(label)
        label.constrainToSuperview([.leading, .top, .trailing, .bottom], insetBy: 32)
        label.textAlignment = .center
        label.hugContent(.vertical)
        label.text = "CalendarAccessError".localized()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("XIBs not supported")
    }

}