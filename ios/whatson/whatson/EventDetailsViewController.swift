import UIKit
import EventKit

class EventDetailsViewController: UIViewController {
    
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
        self.view.backgroundColor = .whiteColor()
        self.navigationItem.title = "Event details"
        
        let titleLabel = UILabel()
        let locationLabel = UILabel()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, locationLabel])
        
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        self.view.addSubview(scrollView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.constrainToSuperview(edge: .Leading, withOffset: 12)
        scrollView.constrainToSuperview(edge: .Trailing, withOffset: 12)
        scrollView.constrainToSuperview(edge: .Top)
        scrollView.constrainToSuperview(edge: .Bottom)
        
        stackView.constrainToSuperview(edge: .Leading)
        stackView.constrainToSuperview(edge: .Trailing)
        
        titleLabel.text = event.title
    }

}


