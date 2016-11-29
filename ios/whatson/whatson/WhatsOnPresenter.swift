import UIKit
import EventKit
import EventKitUI

class WhatsOnPresenter {

    let eventStore: EKEventStore
    let eventService: SCEventsService
    private weak var delegate: WhatsOnPresenterDelegate? = nil

    init(eventStore: EKEventStore, eventService: SCEventsService) {
        self.eventStore = eventStore
        self.eventService = eventService
    }

    func beginPresenting(_ delegate: WhatsOnPresenterDelegate) {
        self.delegate = delegate
        eventStore.requestAccess(to: .event) { [weak self] (access, error) in
            if (access) {
                self?.refreshEvents()
            } else if let error = error {
                self?.delegate?.failedToAccessCalendar(error as NSError)
            }
        }
    }

    func stopPresenting() {
        self.delegate = nil
    }

    func refreshEvents() {
        fetchEvents({ [weak self] (source) in
            self?.delegate?.didUpdateSource(source)
        })
    }

    private func fetchEvents(_ completion: @escaping ((SCCalendarSource) -> Void)) {
        DispatchQueue.global(qos: .default).async {
                    let source = self.eventService.getCalendarSource(with: 14, with: .now)
                    DispatchQueue.main.async {
                        completion(source)
                    }
                };
    }

}

protocol WhatsOnPresenterDelegate: class {
    func didUpdateSource(_ source: SCCalendarSource)

    func failedToAccessCalendar(_ error: NSError)
}
