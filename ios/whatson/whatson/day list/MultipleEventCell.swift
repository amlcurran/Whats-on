import Foundation
import UIKit

class MultipleEventCell: UITableViewCell, Row {

    private let eventView = EventItemView()
    private let secondItems = RoundedRectBorderView(frame: .zero, color: .red)

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
        secondItems.backgroundColor = SlotStyle.full.cellBackground.darkened(by: 0.2).withAlphaComponent(0.6)
        secondItems.corners = [CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner]
        contentView.addSubview(eventView)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        eventView.constrain(toSuperview: .leading, .trailing, .top)
        contentView.addSubview(secondItems)
        secondItems.constrain(toSuperview: .leading, .trailing, insetBy: 16)
        secondItems.constrain(toSuperview: .bottom)
        secondItems.constrain(.top, to: eventView, .bottom)
        secondItems.constrain(height: 10)
    }

    func bound(to item: SCCalendarItem, slot: SCCalendarSlot) -> Self {
        _ = eventView.bound(to: item, slot: slot)
        return self
    }

}
