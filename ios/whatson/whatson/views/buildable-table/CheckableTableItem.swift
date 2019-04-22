//
//  CheckableTableItem.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class CheckableTableItem: TableItem {

    static var cellIdentifier = "checkable"

    let title: String
    let subtitle: String
    let isChecked: Bool
    let isSelectable = true
    let isEnabled = true

    init(title: String, subtitle: String, isChecked: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.isChecked = isChecked
    }

    func bind(to cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        cell.accessoryType = isChecked ? .checkmark : .none
    }

    static func register(in tableView: UITableView) {
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: CheckableTableItem.cellIdentifier)
    }

    var withFlippedCheck: CheckableTableItem {
        return CheckableTableItem(title: title, subtitle: subtitle, isChecked: !isChecked)
    }

}

private class SubtitleCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
