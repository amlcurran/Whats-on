//
//  NewOptionsViewController.swift
//  whatson
//
//  Created by Alex Curran on 05/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class NewOptionsViewController: UIViewController, CalendarsView, DateView {

    private let analytics = Analytics()
    private let calendarPresenter = CalendarPresenter(loader: CalendarLoader(preferenceStore: CalendarPreferenceStore()))
    private let pickerPresenter = DatePickerPresenter(timeStore: UserDefaultsTimeStore())
    private let picker = UIDatePicker()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let pickerSection = StaticTableSection(title: NSLocalizedString("Options.DisplayOptions", comment: "Options"),
                                                   footer: NSLocalizedString("Options.MinuteLimitation", comment: "Minute limitations in the options"),
                                                   items: [])
    private let calendarsSection = StaticTableSection(title: "Calendars", items: [])
    private var pickerHeightConstraint: NSLayoutConstraint!
    private lazy var sections: [TableSection] = self.createSections()
    private lazy var source: BuildableTableSource = self.createSource()

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

    private func createSections() -> [TableSection] {
        return [
            pickerSection,
            calendarsSection
        ]
    }

    private func createSource() -> BuildableTableSource {
        return BuildableTableSource(sections: self.sections, tableView: self.tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutViews()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Navigation Item"), style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Navigation Item"), style: .plain, target: self, action: #selector(doneTapped))

        pickerPresenter.beginPresenting(using: picker, on: self)
        calendarPresenter.beginPresenting(on: self)
    }

    func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    func showPicker() {
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
        let timeStore = UserDefaultsTimeStore()
        analytics.changedTimes(starting: timeStore.startTime, finishing: timeStore.endTime)
        dismiss(animated: true, completion: nil)
    }

    func updateCalendar(_ items: [TableItem]) {
        calendarsSection.items = items
        tableView.reloadSections([1], with: .automatic)
    }

    func updateDate(_ items: [TableItem]) {
        pickerSection.items = items
        tableView.reloadSections([0], with: .automatic)
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
