//
//  TableSection.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation

protocol TableSection {
    var title: String { get }
    var footer: String? { get }
    var itemCount: Int { get }
    func item(at index: Int) -> TableItem
}

class StaticTableSection: TableSection {
    let title: String
    let footer: String?
    var items: [TableItem]

    init(title: String, footer: String? = nil, items: [TableItem]) {
        self.title = title
        self.footer = footer
        self.items = items
    }

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> TableItem {
        return items[index]
    }
}
