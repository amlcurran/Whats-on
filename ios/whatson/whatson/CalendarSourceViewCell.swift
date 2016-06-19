//
//  CalendarSourceViewCell.swift
//  whatson
//
//  Created by Alex on 23/10/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

import Foundation
import UIKit

class CalendarSourceViewCell : UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var centreInParentConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    
    let dateFormatter = DateFormatter();
    
    var empty : Bool = true

    @available(iOS 3.0, *) override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dateFormatter.dateFormat = "EEE"
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dateFormatter.dateFormat = "EEE"
        selectionStyle = .none
    }

    func bind(_ item : SCCalendarItem, slot : SCCalendarSlot?) {
        self.empty = slot?.isEmpty() ?? false
        let startTime = Date.dateFromTime(item.startTime());
        let formatted = String(format: "%@ - %@", dateFormatter.string(from: startTime), item.title());
        let colouredString = NSMutableAttributedString(string: formatted);
        if (item.isEmpty()) {
            let lowRange = NSRange(location: 0, length: colouredString.length)
            colouredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lowTextColor(slot), range: lowRange);
        } else {
            let lowRange = NSRange(location: 0, length: 3)
            colouredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lowTextColor(slot), range: lowRange);
        }
        mainLabel.textColor = UIColor.mainTextColor(slot)
        mainLabel.attributedText = colouredString;
        
        if (slot?.count() > 1) {
            numberLabel.text = String(format: "+%lu more event", slot!.count() - 1);
            numberLabel.isHidden = false;
            numberLabel.textColor = UIColor.lowTextColor(slot)
            centreInParentConstraint.isActive = false;
            topSpacingConstraint.isActive = true;
        } else {
            numberLabel.isHidden = true;
            centreInParentConstraint.isActive = true;
            topSpacingConstraint.isActive = false;
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if (selected) {
            roundedView.backgroundColor = UIColor.selectedCellColor(self)
        } else {
            roundedView.backgroundColor = UIColor.cellColor(self)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            roundedView.backgroundColor = UIColor.selectedCellColor(self)
        } else {
            roundedView.backgroundColor = UIColor.cellColor(self)
        }
    }
    
}

private extension UIColor {
    
    static func selectedCellColor(_ cell: CalendarSourceViewCell) -> UIColor {
        if (!cell.empty) {
            return UIColor.appColor().withAlphaComponent(0.4);
        } else {
            return UIColor.appColor().withAlphaComponent(0.2);
        }
    }
    
    static func cellColor(_ cell: CalendarSourceViewCell) -> UIColor {
        if (!cell.empty) {
            return UIColor.appColor()
        } else {
            return UIColor.white()
        }
    }
    
    static func mainTextColor(_ slot: SCCalendarSlot?) -> UIColor {
        if (slot?.count() > 0) {
            return UIColor.white();
        } else {
            return UIColor.black();
        }
    }
    
    static func selectedMainTextColor(_ cell: CalendarSourceViewCell) -> UIColor {
        if (!cell.empty) {
            return UIColor.white();
        } else {
            return UIColor.black();
        }
    }
    
    static func lowTextColor(_ slot: SCCalendarSlot?) -> UIColor {
        if (slot?.count() > 0) {
            return UIColor.white().withAlphaComponent(0.54);
        } else {
            return UIColor.black().withAlphaComponent(0.54);
        }
    }
    
    static func selectedLowTextColor(_ cell: CalendarSourceViewCell) -> UIColor {
        if (!cell.empty) {
            return UIColor.white().withAlphaComponent(0.54);
        } else {
            return UIColor.black().withAlphaComponent(0.54);
        }
    }
    
}
