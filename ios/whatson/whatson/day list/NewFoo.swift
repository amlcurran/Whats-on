//
//  NewFoo.swift
//  whatson
//
//  Created by Alex Curran on 24/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class NewFoo: NSObject, CalendarTable, UICollectionViewDataSource {

    weak var delegate: CalendarTableViewDelegate?
    private let flowLayout = UICollectionViewCompositionalLayout(section: NSCollectionLayoutSection(group: NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80)), subitems: [
            NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        ])))
    private let dataSource: UICollectionViewDiffableDataSource<String, String>
    private let collectionView: UICollectionView
    private let dataProvider: DataProvider
    var view: UIView { collectionView }

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier, for: indexPath)
        }
    }

    func update(_ source: SCCalendarSource) {
        let snapshot = NSDiffableDataSourceSnapshot<String, String>()
        _ = dataProvider.update(from: source)

        dataSource.apply(snapshot)
    }

    func selection(under point: CGPoint) -> (UIView, SCCalendarItem)? {
        return nil
    }

    func show() {

    }

    func hide() {

    }

    func style() {
        collectionView.dataSource = dataSource
        collectionView.register(EventCollectionCell.self, forCellWithReuseIdentifier: "event")
        collectionView.register(DayCollectionCell.self, forCellWithReuseIdentifier: "day")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.count * 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.isDay {
            // swiftlint:disable:next force_cast
            let foo = collectionView.dequeueReusableCell(withReuseIdentifier: "day", for: indexPath) as! DayCollectionCell
            // swiftlint:disable:next force_unwrap
            _ = foo.bound(to: dataProvider.item(at: indexPath.dataIndexPath)!)
            return foo
        }
        // swiftlint:disable:next force_cast
        let bar = collectionView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as! EventCollectionCell
        let item = dataProvider.item(at: indexPath.dataIndexPath).required()
        let slot = dataProvider.slot(at: indexPath.dataIndexPath).required()
        _ = bar.bound(to: item, slot: slot)
        return bar
    }

}
