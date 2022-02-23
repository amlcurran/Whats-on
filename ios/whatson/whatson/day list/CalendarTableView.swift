import UIKit
import Core
import SwiftUI

enum DiffableType: Hashable {
    case dayTitle(CalendarSlot)
    case emptySlot(CalendarSlot)
    case singleEventSlot(EventCalendarItem)
}

private extension NSCollectionLayoutItem {

    static var fullSize: NSCollectionLayoutItem {
        NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
    }

}


private extension NSCollectionLayoutSection {

    static var staticSection: NSCollectionLayoutSection {
        let staticSection = NSCollectionLayoutSection(group: .vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(72)),
            subitems: [NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(72))
            )]
        ))
        staticSection.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(24)), elementKind: "Header", alignment: .top)
        ]
        staticSection.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        return staticSection
    }

    static var horizontalScrollingSection: NSCollectionLayoutSection {
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(72)),
            subitems: [NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(72))
            )]
        )
        let scrollableSection = NSCollectionLayoutSection(group: group)
        scrollableSection.orthogonalScrollingBehavior = .groupPaging
        scrollableSection.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(24)), elementKind: "Header", alignment: .top)
        ]
        scrollableSection.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        return scrollableSection
    }

}

class CalendarDiffableTableView: NSObject, UICollectionViewDelegate {

    private var tableView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Date, DiffableType>!
    private weak var delegate: CalendarTableViewDelegate?

    var view: UIView {
        tableView
    }
    
    var sharingMode = false {
        didSet {
            tableView.reloadData()
        }
    }

    init(tableView: UITableView, delegate: CalendarTableViewDelegate) {
        self.delegate = delegate
        super.init()
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let sectionId = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            if self.dataSource.snapshot().itemIdentifiers(inSection: sectionId).count > 1 {
                return .horizontalScrollingSection
            } else {
                return .staticSection
            }
        }
        self.tableView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.dataSource = UICollectionViewDiffableDataSource<Date, DiffableType>(collectionView: self.tableView, cellProvider: { [weak self] (tableView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .emptySlot(let slot):
                let cell = tableView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as? EventCollectionCell
                return cell?.bound(to: slot, sharingMode: self?.sharingMode ?? false)
            case .singleEventSlot(let slot):
                let cell = tableView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as? EventCollectionCell
                return cell?.bound(to: slot, sharingMode: self?.sharingMode ?? false)
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
        self.tableView.register(DayCollectionCell.self, forCellWithReuseIdentifier: "day")
        self.tableView.register(EventCollectionCell.self, forCellWithReuseIdentifier: "event")
        self.tableView.register(MultipleEventCell.self, forCellWithReuseIdentifier: "multievent")
        self.tableView.backgroundColor = .clear
        self.tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }

    func update(_ source: [CalendarSlot]) {
        var snapshot = NSDiffableDataSourceSnapshot<Date, DiffableType>()
        for slot in source {
            snapshot.appendSections([slot.boundaryStart])
            var items = [DiffableType]()
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
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.snapshot().item(for: indexPath)
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

extension NSDiffableDataSourceSnapshot where SectionIdentifierType == Date, ItemIdentifierType == DiffableType {

    func item(for indexPath: IndexPath) -> ItemIdentifierType {
        let sectionId = sectionIdentifiers[indexPath.section]
        return itemIdentifiers(inSection: sectionId)[indexPath.row]
    }

}
