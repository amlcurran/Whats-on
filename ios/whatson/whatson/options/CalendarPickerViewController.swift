//
//  CalendarPickerViewController.swift
//  whatson
//
//  Created by Alex Curran on 12/11/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit
import Core

protocol CalendarPickerViewControllerDelegate: class {
    func didSelect(_ calendar: EventCalendar)
}

class CalendarPickerViewController: UITableViewController {

    private let calendars: [EventCalendar]
    private let selectedCalendar: EventCalendar?
    private weak var delegate: CalendarPickerViewControllerDelegate?

    init(calendars: [EventCalendar], selectedCalendar: EventCalendar?, delegate: CalendarPickerViewControllerDelegate) {
        self.calendars = calendars
        self.selectedCalendar = selectedCalendar
        self.delegate = delegate
        super.init(style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Calendar")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Calendar", for: indexPath)
        cell.textLabel?.text = calendars[indexPath.row].name
        let isSelected = calendars[indexPath.row] == selectedCalendar
        cell.accessoryType = isSelected ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCalendar = calendars[indexPath.row]
        delegate?.didSelect(selectedCalendar)
    }

}
