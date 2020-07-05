import UIKit
import EventKit
import EventKitUI
import Core

class WhatsOnPresenter {

    private let eventStore: EKEventStore
    private let eventService: EventsService
    private let dataProvider: DataProvider
    private let delayer: Delayer
    private weak var view: WhatsOnPresenterView?
    private var notificationHandle: Any?

    init(eventStore: EKEventStore, eventService: EventsService, dataProvider: DataProvider) {
        self.eventStore = eventStore
        self.eventService = eventService
        self.dataProvider = dataProvider
        self.delayer = Delayer(queue: .main)
    }

    func beginPresenting(on view: WhatsOnPresenterView, delayingBy delay: DispatchTimeInterval = .seconds(0)) {
        self.view = view
        delayer.delayUpcomingEvents(by: delay)
        notificationHandle = NotificationCenter.default.addObserver(forName: .EKEventStoreChanged, do: { [weak self] in
            self?.refreshEvents()
        })
        eventStore.requestAccess(to: .event) { [weak self] (hasAccess, error) in
            if hasAccess {
                self?.refreshEvents()
            } else if error != nil {
                self?.view?.showAccessFailure()
            }
        }
    }

    func stopPresenting() {
        self.view = nil
        NotificationCenter.default.removeOptionalObserver(notificationHandle)
    }

    @objc func refreshEvents() {
        fetchEvents({ [weak self] (source) in
            self?.delayer.runAfterExpiryTime({ [weak self] in
                self?.view?.showCalendar(source)
            })
        })
    }

    private func fetchEvents(_ completion: @escaping ((CalendarSource) -> Void)) {
        DispatchQueue.global(qos: .default).async {
            let source = self.eventService.getCalendarSource(numberOfDays: 14, now: Date())
            DispatchQueue.main.async {
                completion(source)
            }
        }
    }

    func remove(_ event: EventCalendarItem) {
        do {
            if let ekEvent = eventStore.event(withIdentifier: event.eventId) {
                try eventStore.remove(ekEvent, span: .thisEvent)
            }
        } catch {
            view?.failedToDelete(event, withError: error)
        }
    }

}

protocol WhatsOnPresenterView: class {
    func showCalendar(_ source: CalendarSource)

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
