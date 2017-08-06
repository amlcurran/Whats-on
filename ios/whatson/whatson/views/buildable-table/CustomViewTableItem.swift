//
//  CustomViewTableItem.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

struct CustomViewTableItem: TableItem {

    static var cellIdentifier = "customCell"

    let isSelectable = false
    let isEnabled = false
    let customViewFactory: () -> UIView

    func bind(to cell: UITableViewCell) {
        let customView = customViewFactory()
        cell.contentView.addSubview(customView)
        customView.constrainToSuperview([.leadingMargin, .topMargin, .trailingMargin, .bottomMargin])
    }

    static func register(in tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CustomViewTableItem.cellIdentifier)
    }

}
