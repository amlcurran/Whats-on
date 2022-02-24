import UIKit
import EventKit
import CoreLocation
import MapKit

protocol DetailsCardDelegate: AnyObject {
    func didTapMap(on detailsCard: DetailsCard, onRegion region: MKCoordinateRegion)
}

class DetailsCard: UIView {

    private lazy var titleLabel = UILabel()
    private lazy var locationLabel = UILabel()
    private lazy var timingLabel = UILabel()
    private lazy var locationMapView = MKMapView()
    private lazy var line = Line(height: 1, color: .cardDivider)
    private lazy var mapTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped))

    private var mapHeightConstraint: NSLayoutConstraint!
    private var timingTitleContraint: NSLayoutConstraint?

    private let timeFormatter = DateFormatter.shortTime

    private weak var delegate: DetailsCardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        backgroundColor = .surface

        addSubview(titleLabel)
        titleLabel.constrain(toSuperview: .leading, .top, .trailing, insetBy: 16)

        addSubview(timingLabel)
        timingLabel.constrain(toSuperview: .leading, .trailing, insetBy: 16)
        timingTitleContraint = timingLabel.constrain(.top, to: titleLabel, .bottom, withOffset: 4)

        addSubview(line)
        line.constrain(toSuperview: .leading, .trailing, insetBy: 16)
        line.constrain(.top, to: timingLabel, .bottom, withOffset: 16)

        addSubview(locationLabel)
        locationLabel.constrain(toSuperview: .leading, .trailing, insetBy: 16)
        locationLabel.constrain(.top, to: line, .bottom, withOffset: 16)

        let locationHostView = UIView()
        add(locationHostView, constrainedTo: [.leading, .trailing, .bottom])
        mapHeightConstraint = locationHostView.constrain(height: 160)
        locationHostView.constrain(.top, to: locationLabel, .bottom, withOffset: 16)
        locationHostView.addGestureRecognizer(mapTapRecognizer)
        locationHostView.add(locationMapView, constrainedTo: [.leading, .top, .trailing, .bottom])
        
//        hideMap()
    }

    @objc func mapTapped() {
        delegate?.didTapMap(on: self, onRegion: locationMapView.region)
    }

    private func style() {
        titleLabel.set(style: .header)
        locationLabel.set(style: .lower)
        timingLabel.set(style: .lower)
        locationMapView.isUserInteractionEnabled = false
    }

    func set(event: EKEvent, delegate: DetailsCardDelegate) {
        self.delegate = delegate
        titleLabel.text = event.title
        locationLabel.text = event.location
        timingLabel.text = "From \(timeFormatter.string(from: event.startDate)) to \(timeFormatter.string(from: event.endDate))"
    }

    @MainActor
    func hideMap() {
        mapHeightConstraint.constant = 0
    }

    private func expandMap() {
        self.mapHeightConstraint.constant = 160
        superview?.layoutIfNeeded()
    }

    @MainActor
    func show(_ location: CLLocation?) {
        if let location = location {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            locationMapView.setRegion(region, animated: false)
            let point = MKPointAnnotation()
            point.coordinate = location.coordinate
            locationMapView.addAnnotation(point)
            expandMap()
        } else {
            hideMap()
        }
    }

}
