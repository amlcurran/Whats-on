//
//  NewOptionsViewController.swift
//  whatson
//
//  Created by Alex Curran on 05/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit
import Core

class OptionsViewController: UIViewController, CalendarsView, DateView, CalendarPickerViewControllerDelegate {

    private let analytics = Analytics()
    private let calendarPresenter = CalendarPresenter(loader: CalendarLoader(preferenceStore: CalendarPreferenceStore()), preferenceStore: CalendarPreferenceStore())
    private let pickerPresenter = DatePickerPresenter(timeStore: UserDefaultsTimeStore())
    private let picker = UIDatePicker()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let pickerSection = StaticTableSection(title: NSLocalizedString("Options.DisplayOptions", comment: "Options"),
                                                   footer: NSLocalizedString("Options.MinuteLimitation", comment: "Minute limitations in the options"),
                                                   items: [])
    private var defaultCalendarSection: StaticTableSection!
    private var calendarsSection: StaticTableSection!
    private var pickerHeightConstraint: NSLayoutConstraint!
    private var source: BuildableTableSource! {
        didSet {
            tableView.dataSource = source
            tableView.delegate = source
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarsSection = StaticTableSection(title: "Calendars", items: [], onSelect: { (item: TableItem, index: Int) in
            self.calendarPresenter.toggle(item, at: index)
        })
        defaultCalendarSection = StaticTableSection(title: "Other options", footer: nil, items: [], onSelect: { (_, index) in
            let picker = CalendarPickerViewController(calendars: self.calendarPresenter.calendars.onlyEditable, selectedCalendar: self.calendarPresenter.defaultCalendar, delegate: self)
            if self.navigationController == nil {
                preconditionFailure("View wasn't in a navigation controller, even though it was expected to be.")
            }
            self.navigationController?.pushViewController(picker, animated: true)
            self.tableView.deselectRow(at: IndexPath(row: index, section: 1), animated: true)
        })

        source = BuildableTableSource(sections: [pickerSection, defaultCalendarSection, calendarsSection], tableView: tableView)

        layoutViews()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Navigation Item"), style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Navigation Item"), style: .plain, target: self, action: #selector(doneTapped))

        pickerPresenter.beginPresenting(using: picker, on: self)
        calendarPresenter.beginPresenting(on: self)
    }

    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    func showPicker() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pickerHeightConstraint.isActive = false
            self?.view.layoutIfNeeded()
        })
    }

    private func layoutViews() {
        view.backgroundColor = .windowBackground
        view.addSubview(tableView)
        tableView.constrain(toSuperview: .leading, .trailing, .topMargin)

        pickerHeightConstraint = picker.constrain(height: 0)
        pickerHeightConstraint.isActive = true
        view.addSubview(picker)
        picker.constrain(toSuperviewSafeArea: .leading, .trailing, .bottom)
        picker.constrain(.top, to: tableView, .bottom)
    }

    @objc func doneTapped() {
        let timeStore = UserDefaultsTimeStore()
        analytics.changedTimes(starting: timeStore.startTime, finishing: timeStore.endTime)
        dismiss(animated: true, completion: nil)
    }

    func updateCalendar(_ items: [TableItem]) {
        calendarsSection.items = items
        tableView.reload(calendarsSection, from: source)
    }

    func updateSingleCalendar(_ item: TableItem, at index: Int) {
        calendarsSection.items.replaceSubrange(index..<index+1, with: [item])
        tableView.reload(index, in: calendarsSection, from: source)
    }

    func updateDate(_ items: [TableItem]) {
        pickerSection.items = items
        tableView.reload(pickerSection, from: source)
    }

    func updateDefaultCalendar(_ calendar: EventCalendar?) {
        defaultCalendarSection.items = [
            NextStepTableItem(label: "Default calendar", currentValue: calendar?.name)
        ]
        tableView.reload(defaultCalendarSection, from: source)
    }

    func didSelect(_ calendar: EventCalendar) {
        calendarPresenter.defaultCalendar = calendar
        self.navigationController?.popViewController(animated: true)
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
