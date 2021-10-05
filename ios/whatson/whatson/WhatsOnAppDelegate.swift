import Foundation
import UIKit
import EventKit
import EventKitUI
import Core
import SwiftUI
import Intents

@UIApplicationMain
class WhatsOnAppDelegate: NSObject, UIApplicationDelegate, EKEventEditViewDelegate {

    let analytics = Analytics()
    lazy var window: UIWindow? = UIWindow()
    var rootViewController: UIViewController? {
        return window?.rootViewController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window?.tintColor = UIColor.secondary
        window?.rootViewController = UINavigationController(rootViewController: WhatsOnViewController())
        window?.makeKeyAndVisible()
//        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
        print(intent)
        if intent is CheckCalendarIntent {
            print("Returning intent")
            return CheckCalendarHandler()
        }
        return self
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let interaction = userActivity.interaction {
            print(interaction)
            return true
        }
        return false

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
