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
        boundaryView.updateText(from: timeStore)
        view.updateDate(
            [
                CustomViewTableItem(customViewFactory: {
                    return self.boundaryView
                })
            ]
        )
    }

    func boundaryPicker(inState state: BoundaryPickerView.EditState, didChangeValue date: Date) {
        if state == .start {
            timeStore.startTime = Calendar.current.component(.hour, from: date)
        } else if editState == .end {
            timeStore.endTime = Calendar.current.component(.hour, from: date)
        }
    }

}
