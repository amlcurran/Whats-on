//
//  NewOptionsViewController.swift
//  whatson
//
//  Created by Alex Curran on 05/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class NewOptionsViewController: UITableViewController {
    
    let sections = [
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
    
    lazy var source: BuildableTableSource = {
        return BuildableTableSource(sections: self.sections, tableView: self.tableView)
    }()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.tableView.dataSource = source
        self.tableView.delegate = source
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
