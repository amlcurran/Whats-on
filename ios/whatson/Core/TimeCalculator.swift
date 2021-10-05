//
//  TimeCalculator.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

@available(*, deprecated)
public protocol TimeCalculator {

    @available(*, deprecated)
    func add(days: Int, to time: Date) -> Date

    @available(*, deprecated)
    func add(hours: Int, to time: Date) -> Date

}
