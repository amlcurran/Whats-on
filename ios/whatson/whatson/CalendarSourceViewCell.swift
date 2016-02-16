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
    
    func bind(item : SCCalendarItem, slot : SCCalendarSlot?) {
        dateFormatter.dateFormat = "EEE";
        let startTime = NSDate(timeIntervalSince1970: NSTimeInterval(item.startTime().getMillis() / 1000));
        let formatted = String(format: "%@ - %@", dateFormatter.stringFromDate(startTime), item.title());
        let colouredString = NSMutableAttributedString(string: formatted);
        if (item.isEmpty()) {
            colouredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lowTextColor(slot), range: NSMakeRange(0, colouredString.length));
        } else {
            colouredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lowTextColor(slot), range: NSMakeRange(0, 3));
        }
        mainLabel.textColor = UIColor.mainTextColor(slot)
        mainLabel.attributedText = colouredString;
        
        roundedView.backgroundColor = UIColor.cellColor(slot)
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
    
}

private extension UIColor {
    
    static func cellColor(slot: SCCalendarSlot?) -> UIColor {
        if (slot?.count() > 0) {
            return UIColor.appColor();
        } else {
            return UIColor.clearColor();
        }
    }
    
    static func mainTextColor(slot: SCCalendarSlot?) -> UIColor {
        if (slot?.count() > 0) {
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
    
}