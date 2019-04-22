//
//  CalendarPresenter.swift
//  whatson
//
//  Created by Alex Curran on 06/08/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import Foundation

protocol CalendarsView: class {
    func updateCalendar(_ items: [TableItem])
    func updateSingleCalendar(_ item: TableItem, at index: Int)
    func updateDefaultCalendar(_ calendar: EventCalendar?)
}

class CalendarPresenter {

    private let loader: CalendarLoader
    private let preferenceStore: CalendarPreferenceStore
    private weak var view: CalendarsView?
    private(set) var calendars = [EventCalendar]()
    var defaultCalendar: EventCalendar? {
        didSet {
            preferenceStore.defaultCalendar = defaultCalendar?.id
            view?.updateDefaultCalendar(defaultCalendar)
        }
    }

    init(loader: CalendarLoader, preferenceStore: CalendarPreferenceStore) {
        self.loader = loader
        self.preferenceStore = preferenceStore
    }

    func beginPresenting(on view: CalendarsView) {
        self.view = view
        loader.load(onSuccess: { calendars in
            self.calendars = calendars
            let items = calendars.map({ calendar in
                return CheckableTableItem(title: calendar.name, subtitle: calendar.account, isChecked: calendar.included)
            })
            view.updateCalendar(items)
            self.defaultCalendar = calendars.first(where: isDefault)
            view.updateDefaultCalendar(self.defaultCalendar)
        }, onError: { _ in
            let items = [TitleTableItem(title: "No calendars available", isEnabled: false)]
            view.updateCalendar(items)
        })
    }

    func toggle(_ item: TableItem, at index: Int) {
        if let checkableItem = item as? CheckableTableItem {
            let identifier = self.calendars[index].id
            if let index = preferenceStore.excludedCalendars.firstIndex(of: identifier) {
                preferenceStore.excludedCalendars.remove(at: index)
            } else {
                preferenceStore.excludedCalendars.append(identifier)
            }
            let flippedItem = checkableItem.withFlippedCheck
            view?.updateSingleCalendar(flippedItem, at: index)
        }
    }

    private func isDefault(calendar: EventCalendar) -> Bool {
        return calendar.id == preferenceStore.defaultCalendar
    }
}
