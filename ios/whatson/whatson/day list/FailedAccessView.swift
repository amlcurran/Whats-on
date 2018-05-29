import UIKit

class FailedAccessView: UIView {

    init() {
        super.init(frame: .zero)
        let label = UILabel()
        label.set(style: .lower)
        label.numberOfLines = 0
        addSubview(label)
        label.constrain(toSuperview: .leading, .top, .trailing, .bottom, insetBy: 32)
        label.textAlignment = .center
        label.hugContent(.vertical)
        label.text = NSLocalizedString("CalendarAccessError", comment: "When the app can't access the calendar")
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("XIBs not supported")
    }

}
