import Foundation
import UIKit
import Core

class MultipleEventCell: UICollectionViewCell, UICollectionViewDelegate, Row {

    private let eventView = EventItemView()
    private let secondItems = RoundedRectBorderView(frame: .zero, color: .red)
    private let layoutConfig: UICollectionViewCompositionalLayoutConfiguration = {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        return config
    }()
    private lazy var viewLayout = UICollectionViewCompositionalLayout(
        section: NSCollectionLayoutSection(
            group: .horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(80)),
                subitems: [
                    NSCollectionLayoutItem(
                        layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension:  .absolute(80))
                    )
                ]
            )
        ),
        configuration: layoutConfig
    )
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, DiffableType>(collectionView: self.collectionView, cellProvider: { (tableView, indexPath, item) -> UICollectionViewCell? in
        switch item {
        case .emptySlot,
                .multipleEventSlot,
                .dayTitle:
            fatalError()
        case .singleEventSlot(let slot):
            let cell = tableView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as? EventCollectionCell
            return cell?.bound(to: slot)
        }
    })

    var roundedView: RoundedRectBorderView {
        return eventView.roundedView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
        backgroundColor = .clear
    }

    private func layout() {
        collectionView.register(EventCollectionCell.self, forCellWithReuseIdentifier: "event")
        contentView.addSubview(collectionView)
        contentView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.constrain(toSuperview: .leading, .trailing, .top, .bottom)
        collectionView.dataSource = dataSource
        collectionView.constrain(height: 80)
    }

    func bound(to slot: CalendarSlot) -> Self {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DiffableType>()
        snapshot.appendSections([0])
        slot.items.forEach { item in
            snapshot.appendItems([
                .singleEventSlot(item)
            ], toSection: 0)
        }
        dataSource.apply(snapshot)
        return self
    }



}
