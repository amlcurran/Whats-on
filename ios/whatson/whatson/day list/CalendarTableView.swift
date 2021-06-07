import UIKit
import Core

protocol CalendarTable {
    var view: UIView { get }
    func update(_ source: CalendarSource)
    func style()
}

struct Day: Equatable, Hashable {
    let position: Int
    let slot: CalendarSlot
    let item: CalendarItem

    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.position == rhs.position &&
            lhs.slot.count() == lhs.slot.count() &&
            lhs.item.title == rhs.item.title &&
            lhs.item.startTime == rhs.item.endTime &&
            lhs.item.isEmpty == rhs.item.isEmpty
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(slot.count())
        hasher.combine(item.title)
        hasher.combine(item.startTime)
        hasher.combine(item.endTime)
        hasher.combine(item.isEmpty)
    }
}

@available(iOS 13.0, *)
class CalendarDiffableTableView: NSObject, CalendarTable, UITableViewDelegate {

    private let tableView: UITableView
    private let dataSource: UITableViewDiffableDataSource<Int, Day>
    private weak var delegate: CalendarTableViewDelegate?

    var view: UIView {
        tableView
    }

    init(tableView: UITableView, delegate: CalendarTableViewDelegate) {
        self.tableView = tableView
        self.dataSource = UITableViewDiffableDataSource<Int, Day>(tableView: tableView, cellProvider: { (_, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as? EventCell
            return cell?.bound(to: item.item, slot: item.slot)
        })
        self.delegate = delegate
        self.tableView.dataSource = dataSource
        super.init()
        self.tableView.delegate = self
    }

    func update(_ source: CalendarSource) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Day>()
        snapshot.appendSections([0])
        var items = [Day]()
        for i in 0..<source.count() {
            items.append(Day(position: i, slot: source.slotAt(i), item: source.item(at: i)))
        }
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func selection(under point: CGPoint) -> (UIView, CalendarItem)? {
        nil
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
        if item.slot.isEmpty {
            delegate?.addEvent(for: item.item)
        } else {
            guard let calendarItem = item.item as? EventCalendarItem else {
                preconditionFailure("Item isn't empty, but isn't event")
            }
            let cell = tableView.cellForRow(at: indexPath).required(as: (UIView & Row).self)
            delegate?.showDetails(for: calendarItem, at: indexPath, in: cell)
        }
    }

}

class CalendarTableView: NSObject, UITableViewDataSource, UITableViewDelegate, CalendarTable {

    private let tableView: UITableView
    private weak var delegate: CalendarTableViewDelegate?
    private var slots: [CalendarSlot] = []
    private var items: [CalendarItem] = []

    var view: UIView {
        return tableView
    }

    init(delegate: CalendarTableViewDelegate, tableView: UITableView) {
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.isDay {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as? DayCell else {
                preconditionFailure("Tried to dequeue a cell which wasn't a Calendar cell")
            }
            return cell.bound(to: items[indexPath.dataIndexPath.row])
        } else if slots[indexPath.dataIndexPath.row].count() > 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "multipleEvent", for: indexPath) as? MultipleEventCell else {
                preconditionFailure("Tried to dequeue a cell which wasn't a Calendar cell")
            }
            let item = items[indexPath.dataIndexPath.row]
            let slot = slots[indexPath.dataIndexPath.row]
            return cell.bound(to: item, slot: slot)
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as? EventCell else {
                preconditionFailure("Tried to dequeue a cell which wasn't a Calendar cell")
            }
            let item = items[indexPath.dataIndexPath.row]
            let slot = slots[indexPath.dataIndexPath.row]
            return cell.bound(to: item, slot: slot)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slots.count * 2
    }

    func update(_ source: CalendarSource) {
        var changedIndexes = [Int]()
        let oldItems = items
        let oldSlots = slots
        items.removeAll()
        slots.removeAll()
        let sourceCount = Int(source.count())
        for index in 0..<sourceCount {
            let newItem = source.item(at: index)
            let newSlot = source.slotAt(index)
            items.append(newItem)
            slots.append(newSlot)
            if index.isWithinBounds(of: oldSlots) && index.isWithinBounds(of: oldItems) {
                if !newSlot.view(matches: oldSlots[index]) || !matchViews(newItem, oldItems[index]) {
                    changedIndexes.append(index)
                }
            }
        }
        if oldSlots.count != Int(source.count()) {
            changedIndexes.removeAll()
        }
        let indexes = changedIndexes
        if indexes.count > 0 {
            tableView.reloadRows(at: indexes.map { IndexPath.tableIndex(fromData: $0) }, with: .automatic)
        } else {
            tableView.reloadData()
        }
    }

    func selection(under point: CGPoint) -> (UIView, CalendarItem)? {
        return nil
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.isDay {
            return nil
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.dataIndexPath.row]
        if item.isEmpty {
            delegate?.addEvent(for: item)
        } else {
            guard let calendarItem = item as? EventCalendarItem else {
                preconditionFailure("Item isn't empty, but isn't event")
            }
            let cell = tableView.cellForRow(at: indexPath).required(as: (UIView & Row).self)
            delegate?.showDetails(for: calendarItem, at: indexPath, in: cell)
        }
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

}

extension IndexPath {

    var dataIndexPath: IndexPath {
        if row % 2 == 1 {
            return IndexPath(row: (row - 1) / 2, section: section)
        } else {
            return IndexPath(row: row / 2, section: section)
        }
    }

    static func tableIndex(fromData index: Int) -> IndexPath {
        return IndexPath(row: index * 2 + 1, section: 0)
    }

    var isDay: Bool {
        return row % 2 == 0
    }

}

protocol CalendarTableViewDelegate: AnyObject {
    func addEvent(for item: CalendarItem)

    func showDetails(for item: EventCalendarItem, at indexPath: IndexPath, in cell: UIView & Row)

    func remove(_ event: EventCalendarItem)
}
