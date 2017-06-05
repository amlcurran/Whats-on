//
//  NewOptionsViewController.swift
//  whatson
//
//  Created by Alex Curran on 05/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class NewOptionsViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let sections = [
        TableSection(title: "Foo",
                     items: [
                        CustomViewTableItem(customViewFactory: {
                            let view = BoundaryPickerView()
                            view.updateText(from: UserDefaultsTimeStore())
                            //view.backgroundColor = .red
                            return view
                        })
            ])
    ]

    private lazy var source: BuildableTableSource = {
        return BuildableTableSource(sections: self.sections, tableView: self.tableView)
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tableView.dataSource = source
        self.tableView.delegate = source
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        tableView.constrainToSuperview([.leading, .trailing, .topMargin, .bottomMargin])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
