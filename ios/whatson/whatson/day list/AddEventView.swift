//
//  AddNewEventViewControllerFactory.swift
//  whatson
//
//  Created by Alex Curran on 08/11/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation
import EventKitUI
import Core
import SwiftUI

struct AddEventView: UIViewControllerRepresentable {
    
    let slot: CalendarSlot
    let completion: () -> Void
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        
        let view: AddEventView
        
        init(view: AddEventView) {
            self.view = view
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            view.completion()
        }
        
        
    }
    
    typealias UIViewControllerType = EKEventEditViewController
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        EKEventEditViewController(calendarItem: slot)
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(view: self)
    }
    
    
}

fileprivate extension EKEventEditViewController {

    convenience init(calendarItem: CalendarSlot,
                     delegate: EKEventEditViewDelegate? = nil,
                     eventStore: EKEventStore = EKEventStore.instance,
                     calendarPreferenceStore: CalendarPreferenceStore = CalendarPreferenceStore()) {
        self.init()
        self.eventStore = eventStore
        self.event = EKEvent(representing: calendarItem, preferenceStore: calendarPreferenceStore)
        self.editViewDelegate = delegate
    }

}

fileprivate extension EKEvent {

    convenience init(representing calendarItem: CalendarSlot,
                     eventStore: EKEventStore = .instance,
                     preferenceStore: CalendarPreferenceStore) {
        self.init(eventStore: eventStore)
        if let defaultCalendarId = preferenceStore.defaultCalendar?.rawValue {
            self.calendar = eventStore.calendar(withIdentifier: defaultCalendarId)
        }
        self.startDate = calendarItem.boundaryStart
        self.endDate = calendarItem.boundaryEnd
    }

}
