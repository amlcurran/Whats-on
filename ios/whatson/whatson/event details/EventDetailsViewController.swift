import UIKit
import EventKit
import EventKitUI
import MapKit
import CoreLocation
import Core

class EventDetailsViewController: UIViewController, EKEventViewDelegate, UINavigationBarDelegate, EventResponseViewDelegate, EKEventEditViewDelegate, EventView, DetailsCardDelegate {

    lazy var detailsCard = DetailsCard()
    lazy var moreInfoButton = UIButton()
    lazy var navBar = UINavigationBar()
    lazy var tracking = EventDetailsTracking()
    lazy var presenter = EventPresenter(view: self, geocoder: CLGeocoder())

    private let event: EKEvent

    var showingNavBar: Bool {
        didSet {
            navBar.isHidden = !showingNavBar
        }
    }

    convenience init?(item: CalendarItem, showingNavBar: Bool = true) {
        if let eventItem = item as? EventCalendarItem {
            self.init(eventItem: eventItem, showingNavBar: showingNavBar)
        } else {
            return nil
        }
    }

    convenience init(eventItem: EventCalendarItem, showingNavBar: Bool) {
        guard let event = EKEventStore.instance.event(matching: eventItem) else {
            preconditionFailure("Trying to view an event which doesnt exist")
        }
        self.init(event: event, showingNavBar: showingNavBar)
    }

    init(event: EKEvent, showingNavBar: Bool) {
        self.event = event
        self.showingNavBar = showingNavBar
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
        navBar.isHidden = !showingNavBar
        moreInfoButton.setTitle("Show more info", for: .normal)

        moreInfoButton.addTarget(self, action: #selector(moreInfoTapped), for: .touchUpInside)

        updateUI()
        loadLocation()
    }

    func updateUI() {
        detailsCard.set(event: event, delegate: self)
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
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.constrain(toSuperviewSafeArea: .bottom)
        scrollView.constrain(.top, to: navBar, .bottom)
        scrollView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true

        scrollView.addSubview(detailsCard)
        detailsCard.constrain(toSuperview: .top, insetBy: 8)
        detailsCard.constrain(toSuperview: .leading)
        detailsCard.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor).isActive = true
        detailsCard.layout()

        let line = UIView()
        line.backgroundColor = .divider
        scrollView.addSubview(line)
        line.constrain(height: 1)
        line.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor).isActive = true
        line.constrain(.top, to: detailsCard, .bottom, withOffset: 16)

        scrollView.add(moreInfoButton, constrainedTo: [.bottomMargin])
        moreInfoButton.constrain(.top, to: line, .bottom, withOffset: 0)
        moreInfoButton.contentEdgeInsets = UIEdgeInsets(top: 21, left: 21, bottom: 21, right: 21)
        moreInfoButton.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor).isActive = true
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
        if event.hasRecurrenceRules {
            let actionSheet = UIAlertController(title: nil, message: "This event is a recurring one. How many occurrences do you want to delete?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "This event", style: .default, handler: { _ in self.deleteEvent(span: .thisEvent) }))
            actionSheet.addAction(UIAlertAction(title: "All future events", style: .default, handler: { _ in self.deleteEvent(span: .futureEvents) }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Delete this event?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in self.deleteEvent(span: .thisEvent) }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
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

    func didTapMap(on detailsCard: DetailsCard, onRegion region: MKCoordinateRegion) {
        let placemark = MKPlacemark(coordinate: region.center, addressDictionary: nil)
        MKMapItem(placemark: placemark).openInMaps(launchOptions: [
            MKLaunchOptionsMapSpanKey: region.span
        ])
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
