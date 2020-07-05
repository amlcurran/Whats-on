//
//  EmptyCalendarItem.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public struct EmptyCalendarItem: CalendarItem {

    public let startTime: Date
    public let endTime: Date
    public let title: String = "Empty"
    public let isEmpty: Bool = true
}
