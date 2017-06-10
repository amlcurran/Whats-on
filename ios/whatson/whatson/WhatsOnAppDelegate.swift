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
        if #available(iOS 9.0, *) {
            UIApplication.shared.shortcutItems = [.addEventTomorrow]
            guard let options = launchOptions,
                let launchShortcut = options[.shortcutItem] as? UIApplicationShortcutItem else {
                return true
            }

            rootViewController?.dismiss(animated: true, completion: nil)
            return handleShortcutItem(launchShortcut)
        }
        return true
    }

    var rootViewController: UIViewController? {
        return window?.rootViewController
    }

    @available(iOS 9.0, *)
    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        analytics.tapped3DTouchShortcut(type: shortcutItem.type)
        if shortcutItem.matches(.addEventTomorrow) {
            addEventTomorrow()
            return true
        }
        return false
    }

    func addEventTomorrow() {
        guard let event = EKEvent.tomorrow(using: UserDefaultsTimeStore()) else {
            preconditionFailure("Couldn't create an event for tomorrow from shortcut")
        }

        let editController = EKEventEditViewController()
        editController.eventStore = .instance
        editController.event = event
        editController.editViewDelegate = self
        rootViewController?.present(editController, animated: false, completion: nil)
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
        sendEvent(named: "3dtouch", withParameters: ["type": type])
    }

}

extension EKEvent {

    static func tomorrow(using: UserDefaultsTimeStore) -> EKEvent? {
        let timeStore = UserDefaultsTimeStore()
        let event = EKEvent(eventStore: .instance)
        guard let start = Date.startTime(from: timeStore, addingDays: 1),
            let end = Date.endTime(from: timeStore, addingDays: 1) else {
                return nil
        }
        event.startDate = start
        event.endDate = end
        return event
    }

}
