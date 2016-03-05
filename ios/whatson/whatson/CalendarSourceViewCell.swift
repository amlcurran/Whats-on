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
    
    let dateFormatter = NSDateFormatter();

    @IBOutlet weak var topSpacingConstraint: NSLayoutConstraint!
    let dayColor = UIColor.blackColor().colorWithAlphaComponent(0.54);
    @IBOutlet weak var roundedView: UIView!
    
    var empty : Bool = true
    
    func bind(item : SCCalendarItem, slot : SCCalendarSlot?) {
        self.empty = slot?.isEmpty() ?? false
        self.selectionStyle = .None
        dateFormatter.dateFormat = "EEE";
        let startTime = NSDate.dateFromTime(item.startTime());
        let formatted = String(format: "%@ - %@", dateFormatter.stringFromDate(startTime), item.title());
        let colouredString = NSMutableAttributedString(string: formatted);
        if (item.isEmpty()) {
            colouredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lowTextColor(slot), range: NSMakeRange(0, colouredString.length));
        } else {
            colouredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lowTextColor(slot), range: NSMakeRange(0, 3));
        }
        mainLabel.textColor = UIColor.mainTextColor(slot)
        mainLabel.attributedText = colouredString;
        
        if (slot?.count() > 1) {
            numberLabel.text = String(format: "+%lu more event", slot!.count() - 1);
            numberLabel.hidden = false;
            numberLabel.textColor = UIColor.lowTextColor(slot)
            centreInParentConstraint.active = false;
            topSpacingConstraint.active = true;
        } else {
            numberLabel.hidden = true;
            centreInParentConstraint.active = true;
            topSpacingConstraint.active = false;
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if (selected) {
            roundedView.backgroundColor = UIColor.selectedCellColor(self)
        } else {
            roundedView.backgroundColor = UIColor.cellColor(self)
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if (highlighted) {
            roundedView.backgroundColor = UIColor.selectedCellColor(self)
        } else {
            roundedView.backgroundColor = UIColor.cellColor(self)
        }
    }
    
}

private extension UIColor {
    
    static func selectedCellColor(cell: CalendarSourceViewCell) -> UIColor {
        if (!cell.empty) {
            return UIColor.appColor().colorWithAlphaComponent(0.4);
        } else {
            return UIColor.appColor().colorWithAlphaComponent(0.2);
        }
    }
    
    static func cellColor(cell: CalendarSourceViewCell) -> UIColor {
        if (!cell.empty) {
            return UIColor.appColor()
        } else {
            return UIColor.whiteColor()
        }
    }
    
    static func mainTextColor(slot: SCCalendarSlot?) -> UIColor {
        if (slot?.count() > 0) {
            return UIColor.whiteColor();
        } else {
            return UIColor.blackColor();
        }
    }
    
    static func selectedMainTextColor(cell: CalendarSourceViewCell) -> UIColor {
        if (!cell.empty) {
            return UIColor.whiteColor();
        } else {
            return UIColor.blackColor();
        }
    }
    
    static func lowTextColor(slot: SCCalendarSlot?) -> UIColor {
        if (slot?.count() > 0) {
            return UIColor.whiteColor().colorWithAlphaComponent(0.54);
        } else {
            return UIColor.blackColor().colorWithAlphaComponent(0.54);
        }
    }
    
    static func selectedLowTextColor(cell: CalendarSourceViewCell) -> UIColor {
        if (!cell.empty) {
            return UIColor.whiteColor().colorWithAlphaComponent(0.54);
        } else {
            return UIColor.blackColor().colorWithAlphaComponent(0.54);
        }
    }
    
}