//
//  TableItem.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

protocol TableItem {

    static var cellIdentifier: String { get }
    var isSelectable: Bool { get }
    var isEnabled: Bool { get }

    func bind(to cell: UITableViewCell)

    static func register(in tableView: UITableView)

}

extension TableItem {

    var identifier: String {
        return Self.cellIdentifier
    }

}
