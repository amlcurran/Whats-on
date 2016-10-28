import UIKit
import EventKit
import EventKitUI
import MapKit
import FirebaseAnalytics

class EventDetailsViewController: UIViewController, UITextViewDelegate, EKEventViewDelegate, UINavigationBarDelegate {

    lazy var detailsCard: DetailsCard = DetailsCard()
    lazy var moreInfoButton = UIButton()
    lazy var navBar = UINavigationBar()
    lazy var tracking = EventDetailsTracking()
    
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
        #if DEBUG
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEventTapped))
        #endif
        navBar.pushItem(previousItem, animated: false)
        navBar.pushItem(navigationItem, animated: false)
        navBar.delegate = self

        detailsCard.set(event: event)
        moreInfoButton.setTitle("Show more info", for: .normal)
        
        moreInfoButton.addTarget(self, action: #selector(moreInfoTapped), for: .touchUpInside)

        loadLocation()
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
        navBar.constrainToSuperview(edges: [.leading, .trailing])
        navBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.constrainToSuperview(edges: [.bottom, .leading, .trailing])
        scrollView.constrain(.top, to: navBar, .bottom)

        scrollView.add(detailsCard, constrainedTo: [.topMargin, .leadingMargin], withOffset: 16)
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
        } else if let location = event.location {
            detailsCard.hideMap()
            geocoder.geocodeAddressString(location, completionHandler: { [weak self] (places, error) in
                self?.handleGeocoding(places: places)
                })
        }
    }
    
    private func handleGeocoding(places: [CLPlacemark]?) {
        if let places = places, let firstPlace = places.first, let location = firstPlace.location {
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
        if (!event.isDetached) {
            deleteEvent(span: .thisEvent)
        }
        let actionSheet = UIAlertController(title: "Delete event", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "This event", style: .default, handler: { _ in self.deleteEvent(span: .thisEvent) }))
        actionSheet.addAction(UIAlertAction(title: "Future events", style: .default, handler: { _ in self.deleteEvent(span: .futureEvents) }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func deleteEvent(span: EKSpan) {
        let eventStore = EKEventStore()
        do {
            try eventStore.remove(event, span: span)
            _ = navigationController?.popViewController(animated: true)
        } catch {
            print(error)
            let errorView = UIAlertController(title: "An error occurred", message: "The event couldn't be deleted", preferredStyle: .alert)
            errorView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(errorView, animated: true, completion: nil)
        }
    }
    
    public func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
        if (action == .deleted) {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (geocoder.isGeocoding) {
            geocoder.cancelGeocode()
        }
    }

}

fileprivate extension Date {
    
    fileprivate func formatAsTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
}

fileprivate extension EKEventViewController {
    
    convenience init(showing event: EKEvent, delegate: EKEventViewDelegate) {
        self.init()
        self.event = event
        self.delegate = delegate
        self.allowsEditing = false
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

class DetailsCard: UIView {

    lazy var titleLabel = UILabel()
    lazy var locationLabel = UILabel()
    lazy var timingLabel = UILabel()
    lazy var locationMapView = MKMapView()

    var mapHeightConstraint: NSLayoutConstraint!

    func layout() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        backgroundColor = .white

        addSubview(titleLabel)
        titleLabel.constrainToSuperview(edges: [.leading, .top], withOffset: 16)
        titleLabel.constrainToSuperview(edges: [.trailing], withOffset: -16)

        addSubview(timingLabel)
        timingLabel.constrainToSuperview(edges: [.leading], withOffset: 16)
        timingLabel.constrainToSuperview(edges: [.trailing], withOffset: -16)
        timingLabel.constrain(.top, to: titleLabel, .bottom, withOffset: 8)

        let line = UIView()
        line.backgroundColor = .cardDivider
        addSubview(line)
        line.constrain(height: 1)
        line.constrain(.width, to: self, .width)
        line.constrainToSuperview(edges: [.leading, .trailing])
        line.constrain(.top, to: timingLabel, .bottom, withOffset: 16)

        addSubview(locationLabel)
        locationLabel.constrainToSuperview(edges: [.leading], withOffset: 16)
        locationLabel.constrainToSuperview(edges: [.trailing], withOffset: -16)
        locationLabel.constrain(.top, to: line, .bottom, withOffset: 16)

        add(locationMapView, constrainedTo: [.leading, .trailing, .bottom])
        mapHeightConstraint = locationMapView.constrain(height: 136)
        locationMapView.constrain(.top, to: locationLabel, .bottom, withOffset: 16)
    }

    func style() {
        titleLabel.set(style: .header)
        locationLabel.set(style: .lower)
        timingLabel.set(style: .lower)
        locationMapView.isUserInteractionEnabled = false
    }

    func set(event: EKEvent) {
        titleLabel.text = event.title
        locationLabel.text = event.location
        timingLabel.text = "From \(event.startDate.formatAsTime()) to \(event.endDate.formatAsTime())"
    }

    func hideMap() {
        mapHeightConstraint.constant = 0
    }

    func showMap() {
        mapHeightConstraint.constant = 160
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }

    func updateMap(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationMapView.setRegion(region, animated: false)
        let point = MKPointAnnotation()
        point.coordinate = location.coordinate
        locationMapView.addAnnotation(point)
    }

}
