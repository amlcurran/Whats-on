//
//  EventView.swift
//  whatson
//
//  Created by Alex Curran on 25/06/2018.
//  Copyright © 2018 Alex Curran. All rights reserved.
//

import UIKit
import Core

class EventItemView: UIView {

    let eventLabel = UILabel()
    let roundedView = RoundedRectBorderView()
    let timeFormatter = DateFormatter.shortTime
    let timeCalculator = NSDateCalculator.instance
    let secondaryLabel = UILabel()

    var secondaryLabelZeroHeightConstraint: NSLayoutConstraint?
    var secondaryLabelBelowConstraint: NSLayoutConstraint?

    var highlighted: Bool = false {
        didSet {
            roundedView.backgroundColor = highlighted ? type.selectedBackground : type.cellBackground
        }
    }

    private var type: SlotStyle = .empty {
        didSet {
            roundedView.backgroundColor = type.cellBackground
            eventLabel.textColor = type.mainText
            secondaryLabel.textColor = type.secondaryText
            roundedView.borderColor = type.borderColor
            roundedView.borderWidth = type.borderWidth
            roundedView.borderDash = type.borderDash
            updateSecondaryHeight()
        }
    }

    private var detail: SlotDetail = .mid {
        didSet {
            updateSecondaryHeight()
        }
    }

    init() {
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
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        backgroundColor = .clear

        secondaryLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
    }

    private func layout() {
        roundedView.addSubview(eventLabel)
        eventLabel.constrain(toSuperview: .top, .leading, .trailing, insetBy: 16)
        eventLabel.setContentHuggingPriority(.required, for: .vertical)
        roundedView.addSubview(secondaryLabel)
        secondaryLabel.constrain(toSuperview: .leading, .trailing, .bottom, insetBy: 16)
        secondaryLabel.setContentHuggingPriority(.required, for: .vertical)
        secondaryLabelBelowConstraint = secondaryLabel.constrain(.top, to: eventLabel, .bottom, withOffset: 4)
        secondaryLabelZeroHeightConstraint = secondaryLabel.constrain(height: 0)
        updateSecondaryHeight()

        layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        add(roundedView, constrainedTo: [.topMargin, .leadingMargin, .trailingMargin, .bottomMargin])
        roundedView.cornerRadius = 6
        roundedView.layer.shadowOffset = CGSize(width: 0, height: 6)
        roundedView.layer.shadowRadius = 4
        roundedView.layer.shadowColor = UIColor.red.cgColor
    }

    func updateSecondaryHeight() {
        if detail.isSecondaryTextShown && type.isSecondaryTextShown {
            secondaryLabelZeroHeightConstraint?.isActive = false
            secondaryLabelBelowConstraint?.constant = 4
        } else {
            secondaryLabelZeroHeightConstraint?.isActive = true
            secondaryLabelBelowConstraint?.constant = 0
        }
    }

    func bound(to slot: CalendarSlot) {
        if let item = slot.items.first {
            type = .full
            eventLabel.text = item.title
            let startTime = timeFormatter.string(from: item.startTime)
            secondaryLabel.text = String(format: "From %@", startTime)
            eventLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        } else {
            type = .empty
            eventLabel.text = "Add event"
            let startTime = timeFormatter.string(from: slot.boundaryStart)
            secondaryLabel.text = String(format: "From %@", startTime)
            eventLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        }
    }

}
