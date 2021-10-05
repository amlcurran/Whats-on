//
//  BoundaryPickerView.swift
//  whatson
//
//  Created by Alex Curran on 04/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit
import Core

class BoundaryPickerView: UIView {

    enum EditState {
        case none
        case start
        case end
    }

    private let beginningLabel = UILabel()
    private let intermediateLabel = UILabel()
    private let startSelectableView = UIDatePicker()
    private let endSelectableView = UIDatePicker()

    weak var delegate: BoundaryPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        startSelectableView.addTarget(self, action: #selector(didUpdate), for: .valueChanged)
        endSelectableView.addTarget(self, action: #selector(didUpdate), for: .valueChanged)
        layout()
        style()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4

        stackView.addArrangedSubview(beginningLabel)
        stackView.addArrangedSubview(startSelectableView)
        stackView.addArrangedSubview(intermediateLabel)
        stackView.addArrangedSubview(endSelectableView)

        addSubview(stackView)
        stackView.constrain(toSuperview: .leading, .trailing)
        stackView.constrain(toSuperview: .top, withOffset: 8)
        stackView.constrain(toSuperview: .bottom, withOffset: -8)
        stackView.hugContent(.vertical)

        startSelectableView.preferredDatePickerStyle = .inline
        startSelectableView.datePickerMode = .time

        endSelectableView.preferredDatePickerStyle = .inline
        endSelectableView.datePickerMode = .time
        beginningLabel.text = NSLocalizedString("Options.Beginning", comment: "Text explaining the time boundaries")
        intermediateLabel.text = NSLocalizedString("Options.Intermediate", comment: "Text explaining the time boundaries")
    }

    private func style() {
    }

    @objc
    func didUpdate(picker: UIDatePicker) {
        if picker == startSelectableView {
            delegate?.boundaryPicker(inState: .start, didChangeValue: picker.date)
        } else {
            delegate?.boundaryPicker(inState: .end, didChangeValue: picker.date)
        }
    }

    func updateText(from timeStore: UserDefaultsTimeStore) {
        startSelectableView.date = timeStore.startTimestamp
        endSelectableView.date = timeStore.endTimestamp
    }

}

protocol BoundaryPickerViewDelegate: AnyObject {

    func boundaryPickerDidBeginEditing(in state: BoundaryPickerView.EditState)

    func boundaryPicker(inState state: BoundaryPickerView.EditState, didChangeValue: Date)

}
