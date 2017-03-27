import UIKit
import EventKit
import EventKitUI

class WhatsOnPresenter {

    private let eventStore: EKEventStore
    private let eventService: SCEventsService
    private let dataProvider: DataProvider
    private weak var view: WhatsOnPresenterView?

    init(eventStore: EKEventStore, eventService: SCEventsService, dataProvider: DataProvider) {
        self.eventStore = eventStore
        self.eventService = eventService
        self.dataProvider = dataProvider
    }

    func beginPresenting(on view: WhatsOnPresenterView) {
        self.view = view
        eventStore.requestAccess(to: .event) { [weak self] (hasAccess, error) in
            if hasAccess {
                self?.refreshEvents()
            } else if let _ = error {
                self?.view?.showAccessFailure()
            }
        }
    }

    func stopPresenting() {
        self.view = nil
    }

    func refreshEvents() {
        fetchEvents({ [weak self] (source) in
            self?.view?.showCalendar(source)
        })
    }

    private func fetchEvents(_ completion: @escaping ((SCCalendarSource) -> Void)) {
        DispatchQueue.global(qos: .default).async {
            let source = self.eventService.getCalendarSource(with: 14, with: .now)
            DispatchQueue.main.async {
                completion(source)
            }
        }
    }

    func remove(_ event: SCEventCalendarItem) {
        do {
            if let ekEvent = eventStore.event(withIdentifier: event.id__()) {
                try eventStore.remove(ekEvent, span: .thisEvent)
            }
        } catch {
            view?.failedToDelete(event, withError: error)
        }
    }

}

protocol WhatsOnPresenterView: class {
    func showCalendar(_ source: SCCalendarSource)

    func showAccessFailure()

    func failedToDelete(_ event: SCCalendarItem, withError error: Error)
}
