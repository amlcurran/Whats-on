import Foundation
import UIKit

class CalendarSourceViewCell : UITableViewCell {
    
    let dayLabel = UILabel()
    let eventLabel = UILabel()
    let roundedView = RoundedRectBorderView()
    let dateFormatter = DateFormatter()
    
    var type: SlotType = .empty {
        didSet {
            roundedView.backgroundColor = type.cellBackground
            dayLabel.textColor = type.secondaryText
            eventLabel.textColor = type.mainText
            roundedView.borderColor = type.borderColor
        }
    }
    var empty : Bool = true

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        backgroundColor = .clear
        selectionStyle = .none
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        backgroundColor = .clear
        selectionStyle = .none
        layout()
    }
    
    func layout() {
        roundedView.addSubview(eventLabel)
        eventLabel.constrainToSuperview(edges: [.top, .leading], withOffset: 16)
        eventLabel.constrainToSuperview(edges: [.trailing, .bottom], withOffset: -16)
        eventLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        
        contentView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        contentView.add(dayLabel, constrainedTo: [.topMargin, .leadingMargin, .trailingMargin], withOffset: 8)
        contentView.add(roundedView, constrainedTo: [.leadingMargin, .trailingMargin, .bottomMargin])
        roundedView.constrain(.top, to: dayLabel, .bottom, withOffset: 6)
        roundedView.cornerRadius = 6
        roundedView.layer.shadowOffset = CGSize(width: 0, height: 6)
        roundedView.layer.shadowRadius = 4
        roundedView.layer.shadowColor = UIColor.red.cgColor
        
        dayLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        eventLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        
        roundedView.borderWidth = 2
    }

    func bind(_ item : SCCalendarItem, slot : SCCalendarSlot?) {
        type = (slot?.isEmpty() ?? false) ? .empty : .full
        eventLabel.text = item.title()
        dayLabel.text = dateFormatter.string(from:  Date.dateFromTime(item.startTime()))
    }
    
}

private let backgrounds: [SlotType: UIColor] = [ .empty: .clear, .full: .white ]
private let mainTexts: [SlotType: UIColor] = [ .empty: .lightText, .full: .secondary ]
private let secondaryTexts: [SlotType: UIColor] = [ .empty: .lightText, .full: .lightText ]
private let borderColors: [SlotType: UIColor] = [ .empty: .emptyOutline, .full: .clear ]

enum SlotType {
    case empty
    case full
    
    var cellBackground: UIColor {
        return backgrounds[self].or(.white)
    }
    
    var mainText: UIColor {
        return mainTexts[self].or(.secondary)
    }
    
    var secondaryText: UIColor {
        return secondaryTexts[self].or(.lightText)
    }
    
    var borderColor: UIColor {
        return borderColors[self].or(.clear)
    }
}
