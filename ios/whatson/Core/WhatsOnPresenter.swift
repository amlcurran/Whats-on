import UIKit
import EventKit
import SwiftUI

public class WhatsOnPresenter: ObservableObject {

    private let eventStore: EKEventStore
    private let eventService: EventsService
    private let delayer: Delayer
    private var notificationHandle: Any?
    @Published public var events: [CalendarSlot] = []
    @Published public var redaction: RedactionReasons = []

    public init(eventStore: EKEventStore, eventService: EventsService) {
        self.eventStore = eventStore
        self.eventService = eventService
        self.delayer = Delayer(queue: .main)
    }

    public func beginPresenting(delayingBy delay: DispatchTimeInterval = .seconds(0)) {
        delayer.delayUpcomingEvents(by: delay)
        notificationHandle = NotificationCenter.default.addObserver(forName: .EKEventStoreChanged, do: { [weak self] in
            self?.refreshEvents()
        })
        eventStore.requestAccess(to: .event) { [weak self] (hasAccess, error) in
            if hasAccess {
                self?.refreshEvents()
            } else if error != nil {
//                self?.view?.showAccessFailure()
            }
        }
    }

    public func stopPresenting() {
//        self.view = nil
        NotificationCenter.default.removeOptionalObserver(notificationHandle)
    }

    @objc public func refreshEvents() {
        fetchEvents({ [weak self] (source) in
            self?.events = source
        })
    }

    public func redact() {
        redaction = [.privacy]
    }
    
    public func unredact() {
        redaction = []
    }
    
    private func fetchEvents(_ completion: @escaping ([CalendarSlot]) -> Void) {
        DispatchQueue.global(qos: .default).async {
            let source = self.eventService.fetchEvents(inNumberOfDays: 14, startingFrom: Date())
            DispatchQueue.main.async {
                completion(source)
            }
        }
    }

    public func remove(_ event: EventCalendarItem) {
        do {
            if let ekEvent = eventStore.event(withIdentifier: event.eventId) {
                try eventStore.remove(ekEvent, span: .thisEvent)
            }
        } catch {
//            view?.failedToDelete(event, withError: error)
        }
    }

}

public protocol WhatsOnPresenterView: AnyObject {
    func showCalendar(_ source: [CalendarSlot])

    func showAccessFailure()

    func failedToDelete(_ event: CalendarItem, withError error: Error)

    func showLoading()
}

extension NotificationCenter {

    func addObserver(forName name: NSNotification.Name, do change: @escaping (() -> Void)) -> NSObjectProtocol {
        return addObserver(forName: name, object: nil, queue: .main, using: { _ in
            change()
        })
    }

    func removeOptionalObserver(_ observer: Any?) {
        if let observer = observer {
            removeObserver(observer)
        }
    }

}
