import UIKit
import EventKit
import MapKit

class EventDetailsViewController: UIViewController, UITextViewDelegate {
    
    lazy var titleLabel = UILabel()
    lazy var locationLabel = UILabel()
    lazy var timingLabel = UILabel()
    lazy var locationMapView = MKMapView()
    lazy var moreInfoLabel = UILabel()
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
        locationLabel.constrain(.top, to: titleLabel, .bottom, withOffset: 8)
        
        stackView.add(locationMapView, constrainedTo: [.leading, .trailing])
        mapHeightConstraint = locationMapView.constrain(height: 160)
        locationMapView.constrain(.top, to: locationLabel, .bottom, withOffset: 8)
        
        stackView.add(timingLabel, constrainedTo: [.leadingMargin, .trailingMargin])
        timingLabel.constrain(.top, to: locationMapView, .bottom, withOffset: 8)
        
        stackView.add(moreInfoLabel, constrainedTo: [.bottomMargin, .leadingMargin, .trailingMargin])
        moreInfoLabel.constrain(.top, to: timingLabel, .bottom, withOffset: 8)
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "Event details"
        
        titleLabel.text = event.title
        locationLabel.text = event.location
        timingLabel.text = "From \(event.startDate.formatAsTime()) to \(event.endDate.formatAsTime())"
        moreInfoLabel.text = "More info"
        
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(moreInfoTapped))
        moreInfoLabel.isUserInteractionEnabled = true
        moreInfoLabel.addGestureRecognizer(recogniser)
        
        if let location = event.structuredLocation?.geoLocation {
            updateMap(location: location)
        } else {
            if let location = event.location {
                mapHeightConstraint.constant = 0
                geocoder.geocodeAddressString(location, completionHandler: { [weak self] (places, error) in
                    if let places = places, let firstPlace = places.first, let location = firstPlace.location {
                        self?.mapHeightConstraint.constant = 160
                        UIView.animate(withDuration: 0.2, animations: { 
                            self?.view.layoutIfNeeded()
                        })
                        self?.updateMap(location: location)
                    }
                })
            } else {
                
            }
        }
    }
    
    private func updateMap(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationMapView.setRegion(region, animated: false)
        let point = MKPointAnnotation()
        point.coordinate = location.coordinate
        locationMapView.addAnnotation(point)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("woop woop 2")
        return false
    }
    
    func moreInfoTapped() {
        print("woop woop")
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


