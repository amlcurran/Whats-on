import Foundation
import UIKit

class MultipleEventCell: UITableViewCell {

    private let eventView = EventItemView()
    private let secondItems = RoundedRectBorderView(frame: .zero, color: .red)
    private let secondText = UILabel()

    var roundedView: RoundedRectBorderView {
        return eventView.roundedView
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
        backgroundColor = .clear
    }

    private func layout() {
        secondItems.cornerRadius = 6
        secondItems.backgroundColor = UIColor.windowBackground.darkened(by: 0.4).withAlphaComponent(0.3)
        secondItems.corners = [CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner]
        secondText.font = .systemFont(ofSize: 14, weight: .medium)
        secondText.textColor = .white
        contentView.addSubview(eventView)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        eventView.constrain(toSuperview: .leading, .trailing, .top)
        contentView.addSubview(secondItems)
        secondItems.constrain(toSuperview: .leading, .trailing, insetBy: 20)
        secondItems.constrain(toSuperview: .bottom)
        secondItems.constrain(.top, to: eventView, .bottom)
        secondItems.addSubview(secondText)
        secondText.constrain(toSuperview: .leading, .trailing, .top, .bottom, insetBy: 4)
    }

    func bound(to item: SCCalendarItem, slot: SCCalendarSlot) -> Self {
        _ = eventView.bound(to: item, slot: slot)
        secondText.text = String(format: NSLocalizedString("OtherEvents", comment: ""), slot.items().size() - 1)
        return self
    }

}
