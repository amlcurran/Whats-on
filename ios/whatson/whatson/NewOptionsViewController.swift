//
//  NewOptionsViewController.swift
//  whatson
//
//  Created by Alex Curran on 05/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class NewOptionsViewController: UIViewController, BoundaryPickerViewDelegate {

    private let analytics = Analytics()
    private let timeStore = UserDefaultsTimeStore()
    private let picker: UIDatePicker = UIDatePicker()
    private let boundaryView = BoundaryPickerView()
    private var pickerHeightConstraint: NSLayoutConstraint!

    private var editState: BoundaryPickerView.EditState = .none

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private lazy var source: BuildableTableSource = {
        let sections = [
            TableSection(title: "Options.DisplayOptions".localized(),
                         footer: "Options.MinuteLimitation".localized(),
                         items: [
                            CustomViewTableItem(customViewFactory: {
                                self.boundaryView.updateText(from: UserDefaultsTimeStore())
                                self.boundaryView.delegate = self
                                return self.boundaryView
                            })
                ])
        ]
        return BuildableTableSource(sections: sections, tableView: self.tableView)
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tableView.dataSource = source
        self.tableView.delegate = source
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutViews()
        picker.addTarget(self, action: #selector(spinnerUpdated), for: .valueChanged)
        picker.datePickerMode = .time

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done".localized(), style: .plain, target: self, action: #selector(doneTapped))

        updateText()
    }

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func showPicker() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pickerHeightConstraint.isActive = false
            self?.view.layoutIfNeeded()
        })
    }

    private func layoutViews() {
        view.addSubview(tableView)
        tableView.constrainToSuperview([.leading, .trailing, .topMargin])

        pickerHeightConstraint = picker.constrain(height: 0)
        pickerHeightConstraint.isActive = true
        view.add(picker, constrainedTo: [.leading, .trailing, .bottom])
        picker.constrain(.top, to: tableView, .bottom)
    }

    func doneTapped() {
        analytics.changedTimes(starting: timeStore.startTime, finishing: timeStore.endTime)
        dismiss(animated: true, completion: nil)
    }

    func updateText() {
        if editState == .start {
            timeStore.startTime = picker.hour.or(17)
        }
        if editState == .end {
            timeStore.endTime = picker.hour.or(23)
        }
        boundaryView.updateText(from: timeStore)
    }

    func spinnerUpdated() {
        updateText()
    }

    func boundaryPickerDidBeginEditing(in state: BoundaryPickerView.EditState) {
        showPicker()
        editState = state
        if editState == .start {
            picker.set(hour: timeStore.startTime, limitedBefore: timeStore.endTime)
        }
        if editState == .end {
            picker.set(hour: timeStore.endTime, limitedAfter: timeStore.startTime)
        }
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
