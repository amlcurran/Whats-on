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
    private let items: [TableItem]

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

protocol DynamicTableSectionSource: class {
    var itemCount: Int { get }
    func item(at index: Int) -> TableItem
}

class DynamicTableSection: TableSection {

    let title: String
    let footer: String?
    weak var source: DynamicTableSectionSource?

    init(title: String, footer: String? = nil, source: DynamicTableSectionSource) {
        self.title = title
        self.footer = footer
        self.source = source
    }

    var itemCount: Int {
        return (source?.itemCount).or(0)
    }

    func item(at index: Int) -> TableItem {
        let concreteSource = source.required(message: "Source deallocated before item could be retrieved")
        return concreteSource.item(at: index)
    }

}
