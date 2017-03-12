import UIKit
import EventKit
import EventKitUI
import MapKit
import FirebaseAnalytics

class EventDetailsViewController: UIViewController, UITextViewDelegate, EKEventViewDelegate, UINavigationBarDelegate, EventResponseViewDelegate, EKEventEditViewDelegate, EventView {

    lazy var detailsCard: DetailsCard = DetailsCard()
    lazy var moreInfoButton = UIButton()
    lazy var navBar = UINavigationBar()
    lazy var tracking = EventDetailsTracking()
    lazy var responseView: EventResponseView = {
        return EventResponseView(delegate: self)
    }()
    lazy var presenter: EventPresenter = EventPresenter(view: self)

    private let geocoder = CLGeocoder()
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
        if BuildConfig.isDebug() {
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
        navBar.constrainToSuperview([.leading, .trailing])
        navBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

        view.addSubview(responseView)
        responseView.constrainToSuperview([.leading, .trailing, .bottom])
        responseView.constrain(height: 0).isActive = !event.supportsResponses

        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.constrainToSuperview([.leading, .trailing])
        scrollView.constrain(.top, to: navBar, .bottom)
        scrollView.constrain(.bottom, to: responseView, .top)

        scrollView.add(detailsCard, constrainedTo: [.topMargin, .leadingMargin], withInset: 16)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func loadLocation() {
        if let location = event.structuredLocation?.geoLocation {
            detailsCard.updateMap(location: location)
        } else if let location = event.location, !location.isEmpty {
            detailsCard.hideMap()
            geocoder.geocodeAddressString(location, completionHandler:
            when(successful: { [weak self] places in
                self?.showLocationOnMap(places: places)
            }, whenFailed: doNothing))
        } else {
            detailsCard.collapseMap()
        }
    }

    private func showLocationOnMap(places: [CLPlacemark]) {
        if let firstPlace = places.first, let location = firstPlace.location {
            detailsCard.showMap()
            detailsCard.updateMap(location: location)
        }
    }

    func moreInfoTapped() {
        tracking.wantedMoreInfo()
        let eventController = EKEventViewController(showing: event, delegate: self)
        let navigationController = UINavigationController(rootViewController: eventController)
        present(navigationController, animated: true, completion: nil)
    }

    func deleteEventTapped() {
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

    func editEventTapped() {
        tracking.wantedEdit()
        let eventController = EKEventEditViewController(editing: event, delegate: self)
        showDetailViewController(eventController, sender: self)
    }

    func eventUpdated() {
        if event.refresh() {
            updateUI()
            tracking.edited()
        } else {
            _ = navigationController?.popViewController(animated: true)
            let errorView = UIAlertController(title: "An error occurred", message: "This event must be refreshed", preferredStyle: .alert)
            errorView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(errorView, animated: true, completion: nil)
        }
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        if action == .deleted {
            _ = navigationController?.popViewController(animated: true)
        } else if action == .saved {
            eventUpdated()
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
        geocoder.cancelGeocode()
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

}

class EventPresenter {

    private weak var view: EventView?

    init(view: EventView) {
        self.view = view
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

}

protocol EventView: class {

    func eventDeleted()

    func showDeleteError()

}

fileprivate extension EKEventViewController {

    convenience init(showing event: EKEvent, delegate: EKEventViewDelegate) {
        self.init()
        self.event = event
        self.delegate = delegate
        self.allowsEditing = false
    }

}

fileprivate extension EKEventEditViewController {

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
