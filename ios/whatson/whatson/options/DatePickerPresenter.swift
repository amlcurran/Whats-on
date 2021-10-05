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
    func didChangeBoundaries()
}

class DatePickerPresenter: BoundaryPickerViewDelegate {

    private let timeStore: UserDefaultsTimeStore
    private let boundaryView = BoundaryPickerView()
    
    private weak var view: DateView?

    init(timeStore: UserDefaultsTimeStore) {
        self.timeStore = timeStore
    }

    func beginPresenting(on view: DateView) {
        self.view = view
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
            timeStore.startTime = (
                Calendar.current.component(.hour, from: date),
                Calendar.current.component(.minute, from: date)
            )
        } else if state == .end {
            timeStore.endTime = (
                Calendar.current.component(.hour, from: date),
                Calendar.current.component(.minute, from: date)
            )
        }
        view?.didChangeBoundaries()
    }

}
