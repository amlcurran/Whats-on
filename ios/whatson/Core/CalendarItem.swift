//
//  CalendarItem.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public protocol CalendarItem {

    var isEmpty: Bool { get }
    var title: String { get }
    var startTime: Date { get }
    var endTime: Date { get }
}
