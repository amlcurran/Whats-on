//
//  TitleTableItem.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

struct TitleTableItem: TableItem {

    static var cellIdentifier = "singleCell"

    let title: String
    let isSelectable: Bool
    let isEnabled: Bool

    init(title: String, isSelectable: Bool = false, isEnabled: Bool = true) {
        self.title = title
        self.isSelectable = isSelectable
        self.isEnabled = isEnabled
    }

    func bind(to cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.textLabel?.isEnabled = isEnabled
    }

    static func register(in tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TitleTableItem.cellIdentifier)
    }

}
