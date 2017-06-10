//
//  UIApplicationShortcuts.swift
//  whatson
//
//  Created by Alex Curran on 10/06/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

extension UIApplicationShortcutItem {

    static let addEventTommorow = UIMutableApplicationShortcutItem(type: "new-tomorrow",
                                                                   localizedTitle: NSLocalizedString("AddEventTomorrow", comment: "Application shortcut for adding event"),
                                                                   localizedSubtitle: nil,
                                                                   icon: UIApplicationShortcutIcon(type: .add),
                                                                   userInfo: nil)
    
    func matches(_ otherShortcut: UIApplicationShortcutItem) -> Bool {
        return type == otherShortcut.type
    }

}
