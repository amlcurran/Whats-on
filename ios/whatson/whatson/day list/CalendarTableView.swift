import UIKit
import Core

protocol CalendarTable {
    var view: UIView { get }
    func update(_ source: [CalendarSlot], isFirst: Bool)
    func style()
}

enum DiffableType: Hashable {
    case dayTitle(CalendarSlot)
    case emptySlot(CalendarSlot)
    case filledSlot(CalendarSlot)
}

@available(iOS 13.0, *)
class CalendarDiffableTableView: NSObject, CalendarTable, UITableViewDelegate {

    private let tableView: UITableView
    private let dataSource: UITableViewDiffableDataSource<Int, DiffableType>
    private weak var delegate: CalendarTableViewDelegate?

    var view: UIView {
        tableView
    }

    init(tableView: UITableView, delegate: CalendarTableViewDelegate) {
        self.tableView = tableView
        self.dataSource = UITableViewDiffableDataSource<Int, DiffableType>(tableView: tableView, cellProvider: { (_, indexPath, item) -> UITableViewCell? in
            switch item {
            case .emptySlot(let slot):
                let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as? EventCell
                return cell?.bound(to: slot)
            case .filledSlot(let slot):
                let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as? EventCell
                return cell?.bound(to: slot)
            case .dayTitle(let slot):
                let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as? DayCell
                return cell?.bound(to: slot)
            }
        })
        self.delegate = delegate
        self.tableView.dataSource = dataSource
        super.init()
        self.tableView.delegate = self
    }

    func update(_ source: [CalendarSlot], isFirst: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DiffableType>()
        snapshot.appendSections([0])
        var items = [DiffableType]()
        for slot in source {
            items.append(.dayTitle(slot))
            if slot.items.isEmpty {
                items.append(.emptySlot(slot))
            } else {
                items.append(.filledSlot(slot))
            }
        }
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: !isFirst)
    }

    func style() {
        tableView.register(DayCell.self, forCellReuseIdentifier: "day")
        tableView.register(EventCell.self, forCellReuseIdentifier: "event")
        tableView.register(MultipleEventCell.self, forCellReuseIdentifier: "multipleEvent")
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.snapshot().itemIdentifiers[indexPath.row]
        switch item {
        case .dayTitle(_):
            fatalError()
        case .emptySlot(let slot):
            delegate?.addEvent(for: slot)
        case .filledSlot(let slot):
            guard let calendarItem = slot.items.first else {
                preconditionFailure("Item isn't empty, but isn't event")
            }
            let cell = tableView.cellForRow(at: indexPath).required(as: (UIView & Row).self)
            delegate?.showDetails(for: calendarItem, at: indexPath, in: cell)
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if case .dayTitle = dataSource.snapshot().itemIdentifiers[indexPath.row] {
            return nil
        }
        return indexPath
    }

}

protocol CalendarTableViewDelegate: AnyObject {
    func addEvent(for slot: CalendarSlot)

    func showDetails(for item: EventCalendarItem, at indexPath: IndexPath, in cell: UIView & Row)

    func remove(_ event: EventCalendarItem)
}
