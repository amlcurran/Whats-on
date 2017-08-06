//
//  SwitchTableItem.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class SwitchTableItem: NSObject, TableItem {

    static var cellIdentifier = "switch"
    let title: String
    let isSelectable = false
    let isEnabled = false
    let getter: () -> Bool
    let setter: (Bool) -> Void

    init(title: String, getter: @escaping () -> Bool, setter: @escaping (Bool) -> Void) {
        self.title = title
        self.getter = getter
        self.setter = setter
    }

    func bind(to cell: UITableViewCell) {
        let tableSwitch = UISwitch(frame: .zero)
        tableSwitch.isOn = getter()
        tableSwitch.addTarget(self, action: #selector(changed), for: .valueChanged)
        cell.accessoryView = tableSwitch
        cell.textLabel?.text = title
    }

    static func register(in tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SwitchTableItem.cellIdentifier)
    }

    @objc func changed(newValue: Bool) {
        setter(newValue)
    }

}
