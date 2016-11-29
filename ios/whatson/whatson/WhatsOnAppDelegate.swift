import Foundation
import UIKit
import EventKit
import EventKitUI
import Firebase

//import FirebaseAnalytics

class WhatsOnAppDelegate: NSObject, UIApplicationDelegate, EKEventEditViewDelegate {

    var window = UIWindow() as UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        window?.tintColor = UIColor.secondary
        window?.backgroundColor = UIColor.windowBackground
        window?.rootViewController = UINavigationController(rootViewController: WhatsOnViewController())
        window?.makeKeyAndVisible()
        FIRApp.configure()
        if #available(iOS 9.1, *) {
            updateTouchShortcuts(application)
            guard let options = launchOptions, let launchShortcut = options[.shortcutItem] as? UIApplicationShortcutItem else {
                return true
            }

            let rootViewController = self.rootViewController
            rootViewController?.dismiss(animated: true, completion: nil)
            return handleShortcutItem(launchShortcut)
        }
        return true
    }

    var rootViewController: UIViewController? {
        return window?.rootViewController
    }

    @available(iOS 9.1, *)
    func updateTouchShortcuts(_ application: UIApplication) {
        var newIcons = [UIApplicationShortcutItem]()
        let newEventTommorrow = UIMutableApplicationShortcutItem(type: "new-tomorrow",
                localizedTitle: "Add event tomorrow",
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.add),
                userInfo: nil)
        newIcons.append(newEventTommorrow)
        application.shortcutItems = newIcons
    }

    @available(iOS 9.0, *)
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
//        FIRAnalytics.logEvent(withName: "3dtouch", parameters: [ "type" : shortcutItem.type as NSString])
        if (shortcutItem.type == "new-tomorrow") {
            let eventStore = EKEventStore()
            let event = EKEvent(eventStore: eventStore)
            let startDate = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())
            let endDate = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())
            event.startDate = startDate!
            event.endDate = endDate!

            let editController = EKEventEditViewController()
            editController.eventStore = eventStore
            editController.event = event
            editController.editViewDelegate = self
            rootViewController?.present(editController, animated: false, completion: nil)
            return true
        } else if (shortcutItem.type == "on-today") {
            let alertController = UIAlertController(title: "Uh oh!", message: "You've not implemented this yet", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            rootViewController?.present(alertController, animated: true, completion: nil)
            return false
        }
        return false
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        _ = handleShortcutItem(shortcutItem)
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        rootViewController?.dismiss(animated: true, completion: nil)
    }

}
