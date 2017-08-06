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
}

class CalendarPresenter {

    private let loader: CalendarLoader
    private weak var view: CalendarsView?

    init(loader: CalendarLoader) {
        self.loader = loader
    }

    func beginPresenting(on view: CalendarsView) {
        self.view = view
        loader.load(onSuccess: { calendars in
            let items = calendars.map({ calendar in
                return CheckableTableItem(title: calendar.name, isChecked: true)
            })
            view.updateCalendar(items)
        }, onError: { _ in
            let items = [TitleTableItem(title: "No calendars available", isEnabled: false)]
            view.updateCalendar(items)
        })
    }

}
