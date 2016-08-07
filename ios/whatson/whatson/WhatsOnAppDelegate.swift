import Foundation
import UIKit
import EventKit
import EventKitUI
import FirebaseAnalytics

class WhatsOnAppDelegate : NSObject, UIApplicationDelegate, EKEventEditViewDelegate {
    
    var window = UIWindow() as UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.window?.tintColor = UIColor.appColor()
        FIRApp.configure()
        if #available(iOS 9.1, *) {
            updateTouchShortcuts(application)
            guard let options = launchOptions, let launchShortcut = options[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem else {
                return true;
            }
            
            let rootViewController = self.rootViewController()
            rootViewController?.dismiss(animated: true, completion: nil)
            return handleShortcutItem(launchShortcut)
        } else {
            return true;
        }
    }
    
    func rootViewController() -> UIViewController? {
        return window?.rootViewController ?? nil
    }
    
    @available(iOS 9.1, *)
    func updateTouchShortcuts(_ application: UIApplication) {
        var newIcons = [UIApplicationShortcutItem]()
        let newEventTommorrow = UIMutableApplicationShortcutItem(type: "new-tomorrow", localizedTitle: "Add event tomorrow", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.add), userInfo: nil)
        newIcons.append(newEventTommorrow)
        application.shortcutItems = newIcons;
    }
    
    @available(iOS 9.0, *)
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        FIRAnalytics.logEvent(withName: "3dtouch", parameters: [ "type" : shortcutItem.type])
        if (shortcutItem.type == "new-tomorrow") {
            let eventStore = EKEventStore()
            let event = EKEvent(eventStore: eventStore)
            let startDate = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date(), options: Calendar.Options.init(rawValue: 0))
            let endDate = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date(), options: Calendar.Options.init(rawValue: 0))
            event.startDate = startDate!
            event.endDate = endDate!
            
            let editController = EKEventEditViewController()
            editController.eventStore = eventStore
            editController.event = event
            editController.editViewDelegate = self
            let rootViewController = self.rootViewController()
            rootViewController?.present(editController, animated: false, completion: nil)
            return true
        } else if (shortcutItem.type == "on-today") {
            let alertController = UIAlertController(title: "Uh oh!", message: "You've not implemented this yet", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.rootViewController()?.present(alertController, animated: true, completion: nil)
            return false
        }
        return false
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        _ = handleShortcutItem(shortcutItem)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.rootViewController()?.dismiss(animated: true, completion: nil)
    }
    
}
