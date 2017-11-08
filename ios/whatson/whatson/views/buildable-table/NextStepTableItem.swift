//
//  NextStepTableItem.swift
//  whatson
//
//  Created by Alex Curran on 08/11/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class NextStepTableItem: TableItem {

    static var cellIdentifier = "nextStep"

    let isSelectable = true
    let isEnabled = false
    let label: String
    var currentValue: String?

    init(label: String, currentValue: String?) {
        self.label = label
        self.currentValue = currentValue
    }

    func bind(to cell: UITableViewCell) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = label
        cell.detailTextLabel?.text = currentValue
    }

    static func register(in tableView: UITableView) {
        tableView.register(ValueCell.self, forCellReuseIdentifier: NextStepTableItem.cellIdentifier)
    }

}

private class ValueCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
