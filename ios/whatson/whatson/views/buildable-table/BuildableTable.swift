import UIKit

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

class SwitchTableItem: NSObject, TableItem {

    static var cellIdentifier = "switch"
    let title: String
    let isSelectable = false
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
        SwitchTableItem.register(in: tableView)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].itemCount
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].item(at: indexPath.row)
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
        return sections[indexPath.section].item(at: indexPath.row)
    }

}
