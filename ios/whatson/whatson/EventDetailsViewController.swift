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
    lazy var moreInfoLabel = UILabel()
    lazy var tracking = EventDetailsTracking()
    var mapHeightConstraint: NSLayoutConstraint!
    
    private let geocoder = CLGeocoder()
    private let event: EKEvent
    
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
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        locationLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        titleLabel.textColor = .secondary
        locationLabel.textColor = .lightText
        
        titleLabel.text = event.title
        locationLabel.text = event.location
        timingLabel.text = "From \(event.startDate.formatAsTime()) to \(event.endDate.formatAsTime())"
        moreInfoLabel.text = "More info"
        
        moreInfoLabel.isUserInteractionEnabled = true
        moreInfoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moreInfoTapped)))
        
        locationMapView.isUserInteractionEnabled = false
        loadLocation()
    }
    
    private func layoutViews() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.constrainToSuperview(edges: [.top, .bottom, .leading, .trailing])
        
        let stackView = UIView()
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        scrollView.add(stackView, constrainedTo: [.top, .bottom])
        stackView.constrain(.width, to: view, .width)
        
        stackView.add(titleLabel, constrainedTo: [.leadingMargin, .trailingMargin, .topMargin])
        titleLabel.constrainToSuperview(edges: [.leadingMargin, .trailingMargin, .topMargin])
        
        stackView.add(locationLabel, constrainedTo: [.leadingMargin, .trailingMargin])
        locationLabel.constrain(.top, to: titleLabel, .bottom, withOffset: 3)
        
        stackView.add(locationMapView, constrainedTo: [.leading, .trailing])
        mapHeightConstraint = locationMapView.constrain(height: 160)
        locationMapView.constrain(.top, to: locationLabel, .bottom, withOffset: 8)
        
        stackView.add(timingLabel, constrainedTo: [.leadingMargin, .trailingMargin])
        timingLabel.constrain(.top, to: locationMapView, .bottom, withOffset: 8)
        
        stackView.add(moreInfoLabel, constrainedTo: [.bottomMargin, .leadingMargin, .trailingMargin])
        moreInfoLabel.constrain(.top, to: timingLabel, .bottom, withOffset: 8)
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
