//
//  EventForceTouchDisplayer.swift
//  whatson
//
//  Created by Alex Curran on 10/07/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit
import Core

class EventForceTouchDisplayer: NSObject, UIViewControllerPreviewingDelegate {

    private let table: CalendarTable
    private let navigationController: UINavigationController?

    init(table: CalendarTable, navigationController: UINavigationController?) {
        self.table = table
        self.navigationController = navigationController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let selection: (UIView, CalendarItem) = table.selection(under: location) else {
            return nil
        }

        previewingContext.sourceRect = selection.0.frame

        if selection.1.isEmpty {
            return nil
        } else {
            return EventDetailsViewController(item: selection.1, showingNavBar: false)
        }
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        (viewControllerToCommit as? EventDetailsViewController)?.showingNavBar = true
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }

}
