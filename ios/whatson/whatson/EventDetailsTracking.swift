import UIKit
import FirebaseAnalytics

class EventDetailsTracking {

    func viewedEventDetails() {
        FIRAnalytics.logEvent(withName: "event_details", parameters: nil)
    }

    func wantedMoreInfo() {
        FIRAnalytics.logEvent(withName: "event_more_info", parameters: nil)
    }

    func wantedEdit() {
        FIRAnalytics.logEvent(withName: "event_edit_begin", parameters: nil)
    }

    func edited() {
        FIRAnalytics.logEvent(withName: "event_edit_finish", parameters: nil)
    }

}
