//
//  EventForceTouchDisplayer.swift
//  whatson
//
//  Created by Alex Curran on 10/07/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class EventForceTouchDisplayer: NSObject, UIViewControllerPreviewingDelegate {

    private let table: CalendarTableView
    private let navigationController: UINavigationController?

    init(table: CalendarTableView, navigationController: UINavigationController?) {
        self.table = table
        self.navigationController = navigationController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = table.indexPath(under: location),
            let cell = table.cell(at: indexPath),
            let item = table.item(at: indexPath) else {
                return nil
        }

        previewingContext.sourceRect = cell.frame

        if item.isEmpty() {
            return nil
        } else {
            return EventDetailsViewController(item: item, showingNavBar: false)
        }
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        (viewControllerToCommit as? EventDetailsViewController)?.showingNavBar = true
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }

}
