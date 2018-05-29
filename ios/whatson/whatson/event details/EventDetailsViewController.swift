import UIKit
import EventKit
import EventKitUI
import MapKit
import FirebaseAnalytics
import CoreLocation

class EventDetailsViewController: UIViewController, UITextViewDelegate, EKEventViewDelegate, UINavigationBarDelegate, EventResponseViewDelegate, EKEventEditViewDelegate, EventView {

    lazy var detailsCard: DetailsCard = DetailsCard()
    lazy var moreInfoButton = UIButton()
    lazy var navBar = UINavigationBar()
    lazy var tracking = EventDetailsTracking()
    lazy var responseView: EventResponseView = {
        return EventResponseView(delegate: self)
    }()
    lazy var presenter: EventPresenter = EventPresenter(view: self, geocoder: CLGeocoder())

    private let event: EKEvent

    convenience init?(item: SCCalendarItem) {
        if let eventItem = item as? SCEventCalendarItem {
            self.init(eventItem: eventItem)
        } else {
            return nil
        }
    }

    convenience init(eventItem: SCEventCalendarItem) {
        guard let itemId = eventItem.id__(),
              let event = EKEventStore.instance.event(withIdentifier: itemId) else {
            preconditionFailure("Trying to view an event which doesnt exist")
        }
        self.init(event: event)
    }

    init(event: EKEvent) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tracking.viewedEventDetails()

        layoutViews()

        view.backgroundColor = .windowBackground

        moreInfoButton.set(style: .cta)
        detailsCard.style()

        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage.from(color: .windowBackground), for: .default)
        let previousItem = UINavigationItem()
        let navigationItem = UINavigationItem()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = actionItems()
        navBar.pushItem(previousItem, animated: false)
        navBar.pushItem(navigationItem, animated: false)
        navBar.delegate = self
        moreInfoButton.setTitle("Show more info", for: .normal)

        moreInfoButton.addTarget(self, action: #selector(moreInfoTapped), for: .touchUpInside)

        updateUI()
        loadLocation()
    }

    func updateUI() {
        detailsCard.set(event: event)
        responseView.set(event.response)
    }

    func actionItems() -> [UIBarButtonItem] {
        if BuildConfig.Supports.eventEditing {
            return [
                UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEventTapped)),
                UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editEventTapped))
            ]
        } else {
            return [UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEventTapped))]
        }
    }

    @objc private func backTapped() {
        _ = navigationController?.popViewController(animated: true)
    }

    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        _ = navigationController?.popViewController(animated: true)
        return true
    }

    private func layoutViews() {
        view.addSubview(navBar)
        navBar.constrain(toSuperview: .leading, .trailing)
        navBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

        view.addSubview(responseView)
        responseView.constrain(toSuperview: .leading, .trailing, .bottom)
        responseView.hideConstraint().isActive = !(event.supportsResponses && BuildConfig.Supports.eventResponses)

        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.constrain(toSuperviewSafeArea: .leading, .trailing)
        scrollView.constrain(.top, to: navBar, .bottom)
        scrollView.constrain(.bottom, to: responseView, .top)

        scrollView.addSubview(detailsCard)
        detailsCard.constrain(toSuperview: .leading, .top, insetBy: 8)
        detailsCard.constrain(.width, to: view, .width, withOffset: -16)
        detailsCard.layout()

        let line = UIView()
        line.backgroundColor = .divider
        scrollView.addSubview(line)
        line.constrain(height: 1)
        line.constrain(.width, to: view, .width)
        line.constrain(.top, to: detailsCard, .bottom, withOffset: 16)

        scrollView.add(moreInfoButton, constrainedTo: [.bottomMargin])
        moreInfoButton.constrain(.top, to: line, .bottom, withOffset: 0)
        moreInfoButton.contentEdgeInsets = UIEdgeInsets(top: 21, left: 21, bottom: 21, right: 21)
        moreInfoButton.constrain(.width, to: view, .width)
    }

    private func loadLocation() {
        presenter.loadLocation(from: event)
    }

    @objc func moreInfoTapped() {
        tracking.wantedMoreInfo()
        let eventController = EKEventViewController(showing: event, delegate: self)
        let navigationController = UINavigationController(rootViewController: eventController)
        present(navigationController, animated: true, completion: nil)
    }

    @objc func deleteEventTapped() {
        if !event.isDetached {
            deleteEvent(span: .thisEvent)
        } else {
            let actionSheet = UIAlertController(title: "Delete event", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "This event", style: .default, handler: { _ in self.deleteEvent(span: .thisEvent) }))
            actionSheet.addAction(UIAlertAction(title: "Future events", style: .default, handler: { _ in self.deleteEvent(span: .futureEvents) }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }
    }

    @objc func editEventTapped() {
        tracking.wantedEdit()
        let eventController = EKEventEditViewController(editing: event, delegate: self)
        showDetailViewController(eventController, sender: self)
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        if action == .deleted {
            _ = navigationController?.popViewController(animated: true)
        } else if action == .saved {
            presenter.handleUpdates(from: event)
        }
    }

    func deleteEvent(span: EKSpan) {
        presenter.delete(event, spanning: span)
    }

    public func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
        if action == .deleted {
            _ = navigationController?.popViewController(animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        presenter.stopPresenting()
    }

    func changeResponse(to state: EventResponse) {
        print(state.asStatus)
    }

    func eventDeleted() {
        _ = navigationController?.popViewController(animated: true)
    }

    func showDeleteError() {
        let errorView = UIAlertController(title: "An error occurred", message: "The event couldn't be deleted", preferredStyle: .alert)
        errorView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(errorView, animated: true, completion: nil)
    }

    func eventUpdated() {
        updateUI()
        tracking.edited()
    }

    func failedToUpdate() {
        _ = navigationController?.popViewController(animated: true)
        let errorView = UIAlertController(title: "An error occurred", message: "This event must be refreshed", preferredStyle: .alert)
        errorView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(errorView, animated: true, completion: nil)
    }

    func expandMap() {
        detailsCard.expandMap()
    }

    func collapseMap() {
        detailsCard.collapseMap()
    }

    func display(_ location: CLLocation) {
        detailsCard.show(location)
    }

}

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

protocol EventView: class {

    func eventDeleted()

    func showDeleteError()

    func eventUpdated()

    func failedToUpdate()

    func expandMap()

    func collapseMap()

    func display(_ location: CLLocation)

}

fileprivate extension EKEventViewController {

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

fileprivate extension UIImage {

    static func from(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }

}
