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
        self.view.backgroundColor = .white()
        self.navigationItem.title = "Event details"
        
        let titleLabel = UILabel()
        let locationLabel = UILabel()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, locationLabel])
        
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        self.view.addSubview(scrollView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        _ = scrollView.constrainToSuperview(edge: .leading, withOffset: 12)
        _ = scrollView.constrainToSuperview(edge: .trailing, withOffset: 12)
        _ = scrollView.constrainToSuperview(edge: .top)
        _ = scrollView.constrainToSuperview(edge: .bottom)
        
        _ = stackView.constrainToSuperview(edge: .leading)
        _ = stackView.constrainToSuperview(edge: .trailing)
        
        titleLabel.text = event.title
    }

}


