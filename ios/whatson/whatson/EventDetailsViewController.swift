import UIKit
import EventKit
import EventKitUI
import MapKit
import FirebaseAnalytics

class EventDetailsViewController: UIViewController, UITextViewDelegate, EKEventViewDelegate {
    
    lazy var titleLabel = UILabel()
    lazy var locationLabel = UILabel()
    lazy var timingLabel = UILabel()
    lazy var locationMapView = MKMapView()
    lazy var moreInfoButton = UIButton()
    lazy var tracking = EventDetailsTracking()
    var mapHeightConstraint: NSLayoutConstraint!
    
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
        edgesForExtendedLayout = []
        tracking.viewedEventDetails()
        
        layoutViews()
        
        view.backgroundColor = .windowBackground
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage.from(color: .windowBackground), for: .default)
        #if DEBUG
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEventTapped))
        #endif
        
        titleLabel.set(style: .header)
        locationLabel.set(style: .lower)
        timingLabel.set(style: .lower)
        moreInfoButton.set(style: .cta)
        
        titleLabel.text = event.title
        locationLabel.text = event.location
        timingLabel.text = "From \(event.startDate.formatAsTime()) to \(event.endDate.formatAsTime())"
        moreInfoButton.setTitle("Show more info", for: .normal)
        
        moreInfoButton.addTarget(self, action: #selector(moreInfoTapped), for: .touchUpInside)
        
        locationMapView.isUserInteractionEnabled = false
        loadLocation()
    }
    
    private func layoutViews() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.constrainToSuperview(edges: [.top, .bottom, .leading, .trailing])
        
        let detailsCard = UIView()
        layout(detailsCard)
        scrollView.add(detailsCard, constrainedTo: [.topMargin, .leadingMargin], withOffset: 16)
        detailsCard.constrain(.width, to: view, .width, withOffset: -16)
        
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
    
    private func layout(_ detailsCard: UIView) {
        detailsCard.layer.cornerRadius = 6
        detailsCard.layer.masksToBounds = true
        detailsCard.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        detailsCard.backgroundColor = .white
        
        detailsCard.addSubview(titleLabel)
        titleLabel.constrainToSuperview(edges: [.leading, .top], withOffset: 16)
        titleLabel.constrainToSuperview(edges: [.trailing], withOffset: -16)
        
        detailsCard.addSubview(timingLabel)
        timingLabel.constrainToSuperview(edges: [.leading], withOffset: 16)
        timingLabel.constrainToSuperview(edges: [.trailing], withOffset: -16)
        timingLabel.constrain(.top, to: titleLabel, .bottom, withOffset: 8)
        
        let line = UIView()
        line.backgroundColor = .cardDivider
        detailsCard.addSubview(line)
        line.constrain(height: 1)
        line.constrain(.width, to: detailsCard, .width)
        line.constrainToSuperview(edges: [.leading, .trailing])
        line.constrain(.top, to: timingLabel, .bottom, withOffset: 16)
        
        detailsCard.addSubview(locationLabel)
        locationLabel.constrainToSuperview(edges: [.leading], withOffset: 16)
        locationLabel.constrainToSuperview(edges: [.trailing], withOffset: -16)
        locationLabel.constrain(.top, to: line, .bottom, withOffset: 16)
        
        detailsCard.add(locationMapView, constrainedTo: [.leading, .trailing, .bottom])
        mapHeightConstraint = locationMapView.constrain(height: 136)
        locationMapView.constrain(.top, to: locationLabel, .bottom, withOffset: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func loadLocation() {
        if let location = event.structuredLocation?.geoLocation {
            updateMap(location: location)
        } else if let location = event.location {
            mapHeightConstraint.constant = 0
            geocoder.geocodeAddressString(location, completionHandler: { [weak self] (places, error) in
                self?.handleGeocoding(places: places)
                })
        }
    }
    
    private func handleGeocoding(places: [CLPlacemark]?) {
        if let places = places, let firstPlace = places.first, let location = firstPlace.location {
            mapHeightConstraint.constant = 160
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            updateMap(location: location)
        }
    }
    
    private func updateMap(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationMapView.setRegion(region, animated: false)
        let point = MKPointAnnotation()
        point.coordinate = location.coordinate
        locationMapView.addAnnotation(point)
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
