import UIKit
import EventKit
import MapKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    private let geocoder = CLGeocoder()
    private let event: EKEvent
    
    init(event: EKEvent) {
        self.event = event
        super.init(nibName: "EventDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Event details"
        
        titleLabel.text = event.title
        locationLabel.text = event.location
        timingLabel.text = "From \(event.startDate.formatAsTime()) to \(event.endDate.formatAsTime())"
        
        if let location = event.structuredLocation?.geoLocation {
            updateMap(location: location)
        } else {
            mapHeightConstraint.constant = 0
            if let location = event.location {
            geocoder.geocodeAddressString(location, completionHandler: { [weak self] (places, error) in
                if let places = places, let firstPlace = places.first, let location = firstPlace.location {
                    self?.mapHeightConstraint.constant = 160
                    UIView.animate(withDuration: 0.2, animations: { 
                        self?.view.layoutIfNeeded()
                    })
                    self?.updateMap(location: location)
                }
            })
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


