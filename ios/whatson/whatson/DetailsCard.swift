import UIKit
import EventKit
import CoreLocation
import MapKit

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

fileprivate extension Date {

    fileprivate func formatAsTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

}
