import Foundation
import UIKit
import EventKit
import EventKitUI
import Firebase

class WhatsOnAppDelegate: NSObject, UIApplicationDelegate, EKEventEditViewDelegate {

    var window = UIWindow() as UIWindow?
    let analytics = Analytics()

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
                localizedTitle: "AddEventTomorrow".localized(),
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.add),
                userInfo: nil)
        newIcons.append(newEventTommorrow)
        application.shortcutItems = newIcons
    }

    @available(iOS 9.0, *)
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        analytics.tapped3DTouchShortcut(type: shortcutItem.type)
        if shortcutItem.type == "new-tomorrow" {
            let timeStore = UserDefaultsTimeStore()
            let eventStore = EKEventStore()
            let event = EKEvent(eventStore: eventStore)
            event.startDate = Date.startTimeIn(days: 1, startTimeFrom: timeStore)!
            event.endDate = Date.endTimeIn(days: 1, endTimeFrom: timeStore)!

            let editController = EKEventEditViewController()
            editController.eventStore = eventStore
            editController.event = event
            editController.editViewDelegate = self
            rootViewController?.present(editController, animated: false, completion: nil)
            return true
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

fileprivate extension Analytics {

    func tapped3DTouchShortcut(type: String) {
        sendEvent(named: "3dtouch", withParameters: ["type" : type])
    }

}

extension Date {

    static func startTimeIn(days: Int, startTimeFrom timeStore: UserDefaultsTimeStore) -> Date? {
        var components = Calendar.current.dateComponents([.day, .minute, .hour, .second, .month, .year], from: Date())
        components.hour = timeStore.startTime
        components.minute = 0
        components.day = components.day.or(0) + days
        return Calendar.current.date(from: components)
    }

    static func endTimeIn(days: Int, endTimeFrom timeStore: UserDefaultsTimeStore) -> Date? {
        var components = Calendar.current.dateComponents([.day, .minute, .hour, .second, .month, .year], from: Date())
        components.hour = timeStore.endTime
        components.minute = 0
        components.day = components.day.or(0) + days
        return Calendar.current.date(from: components)
    }

}
