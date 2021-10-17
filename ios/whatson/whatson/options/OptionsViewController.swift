//
//  NewOptionsViewController.swift
//  whatson
//
//  Created by Alex Curran on 05/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit
import Core
import SwiftUI
import Combine

class OptionsViewController: UIViewController {

    private let analytics = Analytics()
    private let onSetttingsChanged: () -> Void

    init(onSettingsChanged: @escaping () -> Void) {
        self.onSetttingsChanged = onSettingsChanged
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutNewUi()
    }

    private func layoutNewUi() {

        let timeStore = UserDefaultsTimeStore()
        let calendarPreferenceStore = CalendarPreferenceStore()
        let shownCalendars = CalendarLoader(preferenceStore: calendarPreferenceStore).load()
        let optionsView = OptionsView(startDate: timeStore.startDateBinding,
                               endDate: timeStore.endDateBinding,
                               allCalendars: shownCalendars) { [weak self] in
            self?.doneTapped()
        }
//        UITableView.appearance(whenContainedInInstancesOf: [OptionsViewController.self]).backgroundColor = .windowBackground
        let hostingVc = UIHostingController(rootView: optionsView)
        view.addSubview(hostingVc.view)
        hostingVc.view.constrain(toSuperview: .leading, .trailing, .top, .bottom)
        addChild(hostingVc)
        hostingVc.didMove(toParent: self)
    }

    @objc func doneTapped() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.onSetttingsChanged()
    }

}

private extension UITableView {

    func reload(_ section: TableSection, from source: BuildableTableSource) {
        guard let sectionIndex = source.sectionIndex(of: section) else {
            preconditionFailure("Attempting to reload a section \(section) which doesn't exist in the table")
        }
        reloadSections([sectionIndex], with: .automatic)
    }

    func reload(_ index: Int, in section: TableSection, from source: BuildableTableSource) {
        guard let sectionIndex = source.sectionIndex(of: section) else {
            preconditionFailure("Attempting to find a section \(section) which doesn't exist in the table")
        }
        reloadRows(at: [IndexPath(row: index, section: sectionIndex)], with: .automatic)
    }

}

extension UserDefaultsTimeStore {

    var startDateBinding: Binding<Date> {
        Binding(get: {
            self.startTimestamp
        }, set: { date, _ in
            self.startTime = (
                Calendar.current.component(.hour, from: date),
                Calendar.current.component(.minute, from: date)
            )
        })
    }

    var endDateBinding: Binding<Date> {
        Binding(get: {
            self.endTimestamp
        }, set: { date, _ in
            self.endTime = (
                Calendar.current.component(.hour, from: date),
                Calendar.current.component(.minute, from: date)
            )
        })
    }

}

extension Analytics {

    func changedTimes(starting: Int, finishing: Int) {
        sendEvent(named: "timeChange", withParameters: [
            "startTime": "\(starting)",
            "endTime": "\(finishing)"
            ])
    }

    func requestMinutes(repeatedTry: Bool) {
        sendEvent(named: "minuteRequest", withParameters: [
            "repeated": "\(repeatedTry)"
            ])
    }

}
