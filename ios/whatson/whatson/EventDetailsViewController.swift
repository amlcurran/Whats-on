import UIKit
import EventKit
import MapKit

class EventDetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    private let event: EKEvent?
    
    init(event: EKEvent) {
        self.event = event
        super.init(nibName: "EventDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.event = nil
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white()
        self.navigationItem.title = "Event details"
        
//        let titleLabel = UILabel()
//        let locationLabel = UILabel()
//        let map = MKMapView(frame: .zero)
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, locationLabel, map])
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        
//        let scrollView = UIScrollView()
//        scrollView.addSubview(stackView)
//        self.view.addSubview(scrollView)
//        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        _ = scrollView.constrainToSuperview(edge: .leading, withOffset: 12)
//        _ = scrollView.constrainToSuperview(edge: .trailing, withOffset: 12)
//        _ = scrollView.constrainToSuperview(edge: .top)
//        _ = scrollView.constrainToSuperview(edge: .bottom)
//        
//        _ = stackView.constrainToSuperview(edge: .leading)
//        _ = stackView.constrainToSuperview(edge: .trailing)
//        _ = stackView.constrainToSuperview(edge: .top)
//        
//        _ = map.constrain(height: 160)
//        _ = map.constrainToSuperview(edge: .leading)
//        _ = map.constrainToSuperview(edge: .trailing)
//        
        titleLabel.text = event?.title
    }

}


