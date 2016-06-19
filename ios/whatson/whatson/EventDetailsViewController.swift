import UIKit
import EventKit
import MapKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
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
        self.view.backgroundColor = .white()
        self.navigationItem.title = "Event details"
        
        titleLabel.text = event.title
        locationLabel.text = event.location
        
        if let location = event.structuredLocation?.geoLocation {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            locationMapView.setRegion(region, animated: false)
        } else {
            mapHeightConstraint.constant = 0
        }
    }

}


