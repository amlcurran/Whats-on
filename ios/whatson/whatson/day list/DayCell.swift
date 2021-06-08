import UIKit
import Core

class DayCell: UITableViewCell {

    let dayLabel = UILabel()
    let dayFormatter = DateFormatter()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styleViews()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleViews()
        layout()
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
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        contentView.add(dayLabel, constrainedTo: [.leadingMargin, .trailingMargin], withInset: 8)
        dayLabel.constrain(.top, to: contentView, .top, withOffset: 16)
        dayLabel.constrain(.bottom, to: contentView, .bottom, withOffset: -4)
    }

    func bound(to item: CalendarSlot) -> Self {
        dayLabel.text = dayFormatter.string(from: item.boundaryStart)
        return self
    }

}

class DayCollectionCell: UICollectionViewCell {

    let dayLabel = UILabel()
    let dayFormatter = DateFormatter()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        styleViews()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleViews()
        layout()
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
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        contentView.add(dayLabel, constrainedTo: [.leadingMargin, .trailingMargin], withInset: 8)
        dayLabel.constrain(.top, to: contentView, .top, withOffset: 16)
        dayLabel.constrain(.bottom, to: contentView, .bottom, withOffset: -4)
    }

    func bound(to item: CalendarItem) -> Self {
        dayLabel.text = dayFormatter.string(from: item.startTime)
        return self
    }

}
