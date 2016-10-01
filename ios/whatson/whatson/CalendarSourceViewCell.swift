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
    
    let dateFormatter = DateFormatter()
    
    var type: SlotType = .empty {
        didSet {
            roundedView.backgroundColor = type.cellBackground
            mainLabel.textColor = type.mainText
            numberLabel.textColor = type.secondaryText
        }
    }
    var empty : Bool = true

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dateFormatter.dateFormat = "EEE"
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dateFormatter.dateFormat = "EEE"
        backgroundColor = .clear
        selectionStyle = .none
    }

    func bind(_ item : SCCalendarItem, slot : SCCalendarSlot?) {
        type = (slot?.isEmpty() ?? false) ? .empty : .full
        let startTime = Date.dateFromTime(item.startTime());
        let formatted = String(format: "%@ - %@", dateFormatter.string(from: startTime), item.title());
        let colouredString = NSMutableAttributedString(string: formatted);
        if (item.isEmpty()) {
            let lowRange = NSRange(location: 0, length: colouredString.length)
            colouredString.addAttribute(NSForegroundColorAttributeName, value: type.secondaryText, range: lowRange);
        } else {
            let lowRange = NSRange(location: 0, length: 3)
            colouredString.addAttribute(NSForegroundColorAttributeName, value: type.secondaryText, range: lowRange);
        }
        mainLabel.attributedText = colouredString;
        
        let itemCount = slot?.count() ?? 0
        if (itemCount > 1) {
            numberLabel.text = String(format: "+%lu more event", slot!.count() - 1);
            numberLabel.isHidden = false;
            centreInParentConstraint.isActive = false;
            topSpacingConstraint.isActive = true;
        } else {
            numberLabel.isHidden = true;
            centreInParentConstraint.isActive = true;
            topSpacingConstraint.isActive = false;
        }
    }
    
}

private let backgrounds: [SlotType: UIColor] = [ .empty: .clear, .full: .white ]
private let mainTexts: [SlotType: UIColor] = [ .empty: .lightText, .full: .secondary ]
private let secondaryTexts: [SlotType: UIColor] = [ .empty: .lightText, .full: .lightText ]

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
}
