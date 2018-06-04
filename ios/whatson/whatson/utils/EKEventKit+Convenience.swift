import EventKit
import EventKitUI

extension EKEventViewController {

    convenience init(showing event: EKEvent, delegate: EKEventViewDelegate) {
        self.init()
        self.event = event
        self.delegate = delegate
        self.allowsEditing = false
    }

}

extension EKEventEditViewController {

    convenience init(editing event: EKEvent, delegate: EKEventEditViewDelegate) {
        self.init()
        self.event = event
        self.editViewDelegate = delegate
        self.eventStore = .instance
    }

}