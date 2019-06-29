//
//  EmptyCalendarItem.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

struct EmptyCalendarItem: CalendarItem {

    let startTime: Timestamp
    let endTime: Timestamp
    let title: String = "Empty"
    let isEmpty: Bool = true
}
