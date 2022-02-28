import UIKit
import EventKit
import CoreLocation
import MapKit
import SwiftUI

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
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        
        addSubview(stackView)
        stackView.constrain(toSuperview: .bottom)
        stackView.constrain(toSuperview: .leading, .trailing, .top, insetBy: 16)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timingLabel)
        stackView.setCustomSpacing(4, after: titleLabel)
        stackView.addArrangedSubview(line)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(locationMapView)
        mapHeightConstraint = locationMapView.constrain(height: 160)
        locationMapView.addGestureRecognizer(mapTapRecognizer)
        
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

    func set(event: Event, delegate: DetailsCardDelegate) {
        self.delegate = delegate
        titleLabel.text = event.title
        locationLabel.text = event.location
        timingLabel.text = "From \(timeFormatter.string(from: event.startDate)) to \(timeFormatter.string(from: event.endDate))"
    }

    @MainActor
    func hideMap() {
        mapHeightConstraint.constant = 0
        line.isHidden = true
        locationLabel.isHidden = true
    }

    private func expandMap() {
        self.mapHeightConstraint.constant = 160
        line.isHidden = false
        locationLabel.isHidden = false
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

struct Event: Equatable {
    let title: String
    let location: String?
    let startDate: Date
    let endDate: Date
}

struct DetailsCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ViewPreview {
                let card = DetailsCard()
                let event = Event(title: "An event", location: nil, startDate: Date().addingTimeInterval(-60*60), endDate: Date())
                card.set(event: event, delegate: NoOpDetailDelegate())
                card.hideMap()
                return card
            }
            ViewPreview {
                let card = DetailsCard()
                let event = Event(title: "An event", location: "Fink's", startDate: Date().addingTimeInterval(-60*60), endDate: Date())
                card.set(event: event, delegate: NoOpDetailDelegate())
                card.show(CLLocation(latitude: 51.5675456, longitude: -0.105891))
                return card
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

class NoOpDetailDelegate: DetailsCardDelegate {
    func didTapMap(on detailsCard: DetailsCard, onRegion region: MKCoordinateRegion) {
        
    }
    
    
}

struct ViewPreview<T: UIView>: UIViewRepresentable {
    
    typealias UIViewType = T
    let bodyBuilder: () -> T
    
    func updateUIView(_ uiView: T, context: Context) {
        
    }

    func makeUIView(context: Context) -> T {
        return bodyBuilder()
    }
    
}
