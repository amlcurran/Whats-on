import Foundation
import UIKit
import Core
import EventKit

protocol Row {
    var roundedView: RoundedRectBorderView { get }
}

class EventCell: UITableViewCell, Row {

    private let eventView = EventItemView()

    var roundedView: RoundedRectBorderView {
        return eventView.roundedView
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
        backgroundColor = .clear
    }

    private func layout() {
        contentView.addSubview(eventView)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        eventView.constrain(toSuperview: .leading, .trailing, .top, .bottom)
    }

    func bound(to slot: CalendarSlot, sharingMode: Bool) -> Self {
        eventView.bound(to: slot, sharingMode: sharingMode)
        return self
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.1) {
            self.eventView.highlighted = highlighted
        }
    }

}

class EventCollectionCell: UICollectionViewCell, Row {

    private let eventView = EventItemView()

    var roundedView: RoundedRectBorderView {
        return eventView.roundedView
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
        backgroundColor = .clear
    }

    private func layout() {
        contentView.addSubview(eventView)
        contentView.backgroundColor = .clear
        eventView.constrain(toSuperview: .leading, .trailing, .top, .bottom)
    }

    func bound(to slot: CalendarItem, sharingMode: Bool) -> Self {
        eventView.bound(to: slot, sharingMode: sharingMode)
        return self
    }

    func bound(to slot: CalendarSlot, sharingMode: Bool) -> Self {
        eventView.bound(to: slot, sharingMode: sharingMode)
        return self
    }
}

import MapKit

class FullEventCell: UICollectionViewCell, DetailsCardDelegate {
    
    func didTapMap(on detailsCard: DetailsCard, onRegion region: MKCoordinateRegion) {
        //MKMapItem(placemark: MKPlacemark(coordinate: region.center)).openInMaps(launchOptions: nil)
    }
    
    private let eventView = DetailsCard()
    private let geocoder = CLGeocoder()
    private var task: Task<(), Never>?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
        backgroundColor = .clear
    }

    private func layout() {
        contentView.addSubview(eventView)
        contentView.backgroundColor = .clear
        eventView.constrain(toSuperview: .top, .bottom)
        eventView.constrain(toSuperview: .leading, .trailing, insetBy: 8)
    }

    func bind(to event: EKEvent) {
        self.task?.cancel()
        eventView.set(event: event.asEvent, delegate: self)
        self.task = Task {
            let location = await geocoder.loadLocation(from: event)
            eventView.show(location)
        }
        
    }
    
}

extension EKEvent {
    
    var asEvent: Event {
        Event(title: title, location: location, startDate: startDate, endDate: endDate)
    }
    
}
