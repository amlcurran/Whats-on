import UIKit
import EventKit
import CoreLocation
import MapKit

class DetailsCard: UIView {

    lazy var titleLabel = UILabel()
    lazy var locationLabel = UILabel()
    lazy var timingLabel = UILabel()
    lazy var locationMapView = MKMapView()
    lazy var line = Line(height: 1, color: .cardDivider)

    var mapHeightConstraint: NSLayoutConstraint!
    var timingTitleContraint: NSLayoutConstraint?

    func layout() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        backgroundColor = .white

        addSubview(titleLabel)
        titleLabel.constrainToSuperview([.leading, .top, .trailing], insetBy: 16)

        addSubview(timingLabel)
        timingLabel.constrainToSuperview([.leading, .trailing], insetBy: 16)
        timingTitleContraint = timingLabel.constrain(.top, to: titleLabel, .bottom)

        addSubview(line)
        line.constrain(.width, to: self, .width)
        line.constrainToSuperview([.leading, .trailing])
        line.constrain(.top, to: timingLabel, .bottom, withOffset: 16)

        addSubview(locationLabel)
        locationLabel.constrainToSuperview([.leading, .trailing], insetBy: 16)
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

    func collapseMap() {
        mapHeightConstraint.constant = 0
        line.removeFromSuperview()
        locationLabel.removeFromSuperview()
        locationMapView.removeFromSuperview()
        timingLabel.constrainToSuperview([.bottom], insetBy: 16)
    }

    func expandMap() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
            self.mapHeightConstraint.constant = 160
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.superview?.layoutIfNeeded()
            })
        }
    }

    func show(_ location: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        locationMapView.setRegion(region, animated: false)
        let point = MKPointAnnotation()
        point.coordinate = location.coordinate
        locationMapView.addAnnotation(point)
    }

    func expandTitleAndTimeGap() {
        timingTitleContraint?.constant = 8
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.superview?.layoutIfNeeded()
        })
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
