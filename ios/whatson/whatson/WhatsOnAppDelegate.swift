//
//  WhatsOnAppDelegate.swift
//  whatson
//
//  Created by Alex on 11/01/2016.
//  Copyright © 2016 Alex Curran. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import EventKitUI

class WhatsOnAppDelegate : NSObject, UIApplicationDelegate, EKEventEditViewDelegate {
    
    lazy var window = UIWindow() as UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.window?.tintColor = UIColor.appColor()
        if #available(iOS 9.1, *) {
            updateTouchShortcuts(application)
            guard let options = launchOptions, let launchShortcut = options[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem else {
                return true;
            }
            
            let rootViewController = self.rootViewController()
            rootViewController?.dismissViewControllerAnimated(true, completion: nil)
            return handleShortcutItem(launchShortcut)
        } else {
            return true;
        }
    }
    
    func rootViewController() -> UIViewController? {
        return window?.rootViewController ?? nil
    }
    
    @available(iOS 9.1, *)
    func updateTouchShortcuts(application: UIApplication) {
        var newIcons = [UIApplicationShortcutItem]()
        let newEventTommorrow = UIMutableApplicationShortcutItem(type: "new-tomorrow", localizedTitle: "Add event tomorrow", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Add), userInfo: nil)
        let onToday = UIMutableApplicationShortcutItem(type: "on-today", localizedTitle: "On today", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Date), userInfo: nil);
        newIcons.append(newEventTommorrow)
        newIcons.append(onToday)
        application.shortcutItems = newIcons;
    }
    
    @available(iOS 9.0, *)
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        if (shortcutItem.type == "new-tomorrow") {
            let eventStore = EKEventStore()
            let event = EKEvent(eventStore: eventStore)
            let startDate = NSCalendar.currentCalendar().dateBySettingHour(17, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
            let endDate = NSCalendar.currentCalendar().dateBySettingHour(23, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0))
            event.startDate = startDate!
            event.endDate = endDate!
            
            let editController = EKEventEditViewController()
            editController.eventStore = eventStore
            editController.event = event
            let rootViewController = self.rootViewController()
            rootViewController?.presentViewController(editController, animated: false, completion: nil)
            return true
        } else if (shortcutItem.type == "on-today") {
            let alertController = UIAlertController(title: "Uh oh!", message: "You've not implemented this yet", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(action)
            self.rootViewController()?.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        return false
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        handleShortcutItem(shortcutItem)
    }
    
    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        self.rootViewController()?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
