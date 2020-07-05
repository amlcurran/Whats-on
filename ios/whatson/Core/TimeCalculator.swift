//
//  TimeCalculator.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

public protocol TimeCalculator {

    func add(days: Int, to time: Date) -> Date

    func daysSinceEpoch(in date: Date) -> Int

    func add(hours: Int, to time: Date) -> Date

    func dateAtStartOfToday() -> Date

}
