import CoreLocation
import EventKitUI

class EventPresenter {

    private weak var view: EventView?

    private let geocoder: CLGeocoder

    init(view: EventView, geocoder: CLGeocoder) {
        self.view = view
        self.geocoder = geocoder
    }

    func delete(_ event: EKEvent, spanning span: EKSpan) {
        let eventStore = EKEventStore.instance
        do {
            try eventStore.remove(event, span: span)
            view?.eventDeleted()
        } catch {
            view?.showDeleteError()
        }
    }

    func handleUpdates(from event: EKEvent) {
        if event.refresh() {
            view?.eventUpdated()
        } else {
            view?.failedToUpdate()
        }
    }

    func loadLocation(from event: EKEvent) {
        if let location = event.structuredLocation?.geoLocation {
            view?.display(location)
        } else if let location = event.location, !location.isEmpty {
            view?.collapseMap()
            geocoder.geocodeAddressString(location, completionHandler:
            when(successful: { [weak self] places in
                if let firstPlace = places.first, let location = firstPlace.location {
                    self?.view?.expandMap()
                    self?.view?.display(location)
                }
            }, whenFailed: doNothing))
        } else {
            view?.collapseMap()
        }
    }

    func stopPresenting() {
        geocoder.cancelGeocode()
    }

}