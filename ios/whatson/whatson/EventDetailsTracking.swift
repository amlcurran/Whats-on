import UIKit
import FirebaseAnalytics

class EventDetailsTracking {
    
    func viewedEventDetails() {
        FIRAnalytics.logEvent(withName: "event_details", parameters: nil)
    }
    
    func wantedMoreInfo() {
        FIRAnalytics.logEvent(withName: "event_more_info", parameters: nil)
    }

}
