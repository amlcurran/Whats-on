import UIKit

struct TableSection {
    let title: String
    let items: [TableItem]
}

protocol TableItem {
    
    static var cellIdentifier: String { get }
    var isSelectable: Bool { get }
    
    func bind(to cell: UITableViewCell)
    
    static func register(in tableView: UITableView)
    
}

extension TableItem {
    
    var identifier: String {
        return Self.cellIdentifier
    }
    
}

struct TitleTableItem: TableItem {
    
    static var cellIdentifier = "singleCell"
    
    let title: String
    let isSelectable = false
    
    func bind(to cell: UITableViewCell) {
        cell.textLabel?.text = title
    }
    
    static func register(in tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TitleTableItem.cellIdentifier)
    }
    
}

struct CustomViewTableItem: TableItem {
    
    static var cellIdentifier = "singleCell"
    
    let isSelectable = false
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

class BuildableTableSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let sections: [TableSection]
    
    init(sections: [TableSection], tableView: UITableView) {
        self.sections = sections
        TitleTableItem.register(in: tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        item.bind(to: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if item(at: indexPath).isSelectable {
            return indexPath
        } else {
            return nil
        }
    }
    
    private func item(at indexPath: IndexPath) -> TableItem {
        return sections[indexPath.section].items[indexPath.row]
    }
    
}
