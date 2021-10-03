import UIKit
import Core

enum DiffableType: Hashable {
    case dayTitle(CalendarSlot)
    case emptySlot(CalendarSlot)
    case singleEventSlot(EventCalendarItem)
}

class CalendarDiffableTableView: NSObject, UICollectionViewDelegate {

    private var tableView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Date, DiffableType>!
    private weak var delegate: CalendarTableViewDelegate?

    var view: UIView {
        tableView
    }

    init(tableView: UITableView, delegate: CalendarTableViewDelegate) {
        self.delegate = delegate
        super.init()
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = false
        config.trailingSwipeActionsConfigurationProvider = { (indexPath: IndexPath?) in
            if let indexPath = indexPath {
                let snapshot = self.dataSource.snapshot()
                let item = snapshot.itemIdentifiers(inSection: snapshot.sectionIdentifiers[indexPath.section])[indexPath.row]
                if case let DiffableType.singleEventSlot(slot) = item {
                    return UISwipeActionsConfiguration(actions: [
                        UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, handler in
                            self.delegate?.remove(slot)
                            handler(true)
                        })
                    ])
                }
            }
            return nil
        }
        config.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        self.tableView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.dataSource = UICollectionViewDiffableDataSource<Date, DiffableType>(collectionView: self.tableView, cellProvider: { (tableView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .emptySlot(let slot):
                let cell = tableView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as? EventCollectionCell
                return cell?.bound(to: slot)
            case .singleEventSlot(let slot):
                let cell = tableView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as? EventCollectionCell
                return cell?.bound(to: slot)
            case .dayTitle(let slot):
                let cell = tableView.dequeueReusableCell(withReuseIdentifier: "day", for: indexPath) as? DayCollectionCell
                return cell?.bound(to: slot.boundaryStart)
            }
        })
        let headerRegistration = UICollectionView.SupplementaryRegistration<DayCollectionReusableView>(elementKind: "Header") { supplementaryView, String, indexPath in
            _ = supplementaryView.bound(to: self.dataSource.snapshot().sectionIdentifiers[indexPath.section])
        }
        self.dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }

    func update(_ source: [CalendarSlot]) {
        var snapshot = NSDiffableDataSourceSnapshot<Date, DiffableType>()
        for slot in source {
            snapshot.appendSections([slot.boundaryStart])
            var items = [DiffableType]()
//            items.append(.dayTitle(slot))
            if slot.items.isEmpty {
                items.append(.emptySlot(slot))
            } else {
                items.append(contentsOf: slot.items.map(DiffableType.singleEventSlot))
            }
            snapshot.appendItems(items)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func style() {
        tableView.register(DayCollectionCell.self, forCellWithReuseIdentifier: "day")
        tableView.register(EventCollectionCell.self, forCellWithReuseIdentifier: "event")
        tableView.register(MultipleEventCell.self, forCellWithReuseIdentifier: "multievent")
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.snapshot().itemIdentifiers[indexPath.row]
        switch item {
        case .dayTitle:
            fatalError()
        case .emptySlot(let slot):
            delegate?.addEvent(for: slot)
        case .singleEventSlot(let item):
            let cell = tableView.cellForItem(at: indexPath).required(as: (UIView & Row).self)
            delegate?.showDetails(for: item, at: indexPath, in: cell)
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if case .dayTitle = dataSource.snapshot().itemIdentifiers[indexPath.row] {
            return false
        }
        return true
    }

}

protocol CalendarTableViewDelegate: AnyObject {
    func addEvent(for slot: CalendarSlot)

    func showDetails(for item: EventCalendarItem, at indexPath: IndexPath, in cell: UIView & Row)

    func remove(_ event: EventCalendarItem)
}
