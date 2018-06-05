import UIKit

class DayCell: UITableViewCell {

    private let dayView = DayView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }

    private func layout() {
        contentView.add(dayView, constrainedTo: [.leading, .trailing, .top, .bottom])
    }

    func bound(to item: SCCalendarItem) -> Self {
        dayView.bind(to: item)
        return self
    }

}

class DayView: UIView {

    private let dayLabel = UILabel()
    private let dayFormatter = DateFormatter()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func styleViews() {
        dayFormatter.dateStyle = .full
        dayFormatter.timeStyle = .none
        dayFormatter.doesRelativeDateFormatting = true
        backgroundColor = .clear

        dayLabel.textColor = .lightText
        dayLabel.font = .systemFont(ofSize: 14, weight: UIFont.Weight.medium)
    }

    private func layout() {
        layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        add(dayLabel, constrainedTo: [.leadingMargin, .trailingMargin], withInset: 8)
        dayLabel.constrain(.top, to: self, .top, withOffset: 16)
        dayLabel.constrain(.bottom, to: self, .bottom, withOffset: -4)
    }

    func bind(to item: SCCalendarItem) {
        dayLabel.text = dayFormatter.string(from: Date(from: item.startTime()))
    }

}
