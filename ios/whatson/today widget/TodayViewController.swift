//
//  TodayViewController.swift
//  Today
//
//  Created by Alex Curran on 25/06/2018.
//  Copyright © 2018 Alex Curran. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var itemView: EventItemView!
    private var eventService: SCEventsService!
    private let timeRepo = TimeRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        let store = CalendarPreferenceStore()
        let eventRepo = EventStoreRepository(timeRepository: timeRepo, calendarPreferenceStore: store)
        eventService = SCEventsService(scTimeRepository: timeRepo, with: eventRepo, with: NSDateCalculator.instance)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        let source = eventService.getCalendarSource(with: 2, with: .now)
        if source.count() > 0, let item = source.itemAt(with: 0) {
            itemView.bound(to: item, slot: source.slotAt(with: 0))
            completionHandler(.newData)
        } else {
            completionHandler(.failed)
        }
    }

}

private func foo(source: SCCalendarSource) -> String {
    let range = 0..<source.count()
    let slots = range.map { index in
        return "Slot: \(bar(source.slotAt(with: index)))"
    }
    let items = range.map { index -> String in
        if let item = source.itemAt(with: index) {
            return "Item: \(baz(item))"
        } else {
            return "Item: empty"
        }
    }
    return """
    Source: items: {
    slots:
        \(slots.joined(separator: "\n"))
    items:
        \(items.joined(separator: "\n"))
    }
    """
}

private let simpleFormatter: DateFormatter = {
    let f = DateFormatter()
    f.timeStyle = .short
    f.dateStyle = .short
    f.doesRelativeDateFormatting = true
    return f
}()

private func bar(_ slot: SCCalendarSlot) -> String {
    return "item count \(slot.count()), \(String(describing: slot.firstItem()))"
}

private func baz(_ item: SCCalendarItem) -> String {
    return "item at \(simpleFormatter.string(from: NSDateCalculator.instance.date(from: item.startTime()))): \(item.title())"
}
