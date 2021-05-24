//
//  DatePickerPresenter.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit
import Core

protocol DateView: AnyObject {
    func updateDate(_ items: [TableItem])
    func showPicker()
}

class DatePickerPresenter: BoundaryPickerViewDelegate {

    private let timeStore: UserDefaultsTimeStore
    private let boundaryView = BoundaryPickerView()

    private var editState: BoundaryPickerView.EditState = .none
    private weak var picker: UIDatePicker?
    private weak var view: DateView?

    init(timeStore: UserDefaultsTimeStore) {
        self.timeStore = timeStore
    }

    func beginPresenting(using picker: UIDatePicker, on view: DateView) {
        self.view = view
        self.picker = picker
        boundaryView.delegate = self
        updateText()
        picker.addTarget(self, action: #selector(spinnerUpdated), for: .valueChanged)
        picker.datePickerMode = .time
        view.updateDate(
            [
                CustomViewTableItem(customViewFactory: {
                    return self.boundaryView
                })
            ]
        )
    }

    @objc func spinnerUpdated() {
        updateText()
    }

    func updateText() {
        if editState == .start {
            timeStore.startTime = (picker?.hour).or(17)
        }
        if editState == .end {
            timeStore.endTime = (picker?.hour).or(23)
        }
        boundaryView.updateText(from: timeStore)
    }

    func boundaryPickerDidBeginEditing(in state: BoundaryPickerView.EditState) {
        view?.showPicker()
        editState = state
        if editState == .start {
            picker?.set(hour: timeStore.startTime, limitedBefore: timeStore.endTime)
        }
        if editState == .end {
            picker?.set(hour: timeStore.endTime, limitedAfter: timeStore.startTime)
        }
    }

}
