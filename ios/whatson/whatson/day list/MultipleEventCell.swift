import Foundation
import UIKit

class MultipleEventCell: UITableViewCell {

    private let eventView = EventItemView()

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
        contentView.addSubview(eventView)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        eventView.constrain(toSuperview: .leading, .trailing, .top, .bottom)
    }

    func bound(to item: SCCalendarItem, slot: SCCalendarSlot) -> Self {
        _ = eventView.bound(to: item, slot: slot)
        return self
    }

}
