//
//  TimeCalculator.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

protocol TimeCalculator {

    func plusDays(days: Int, time: Timestamp) -> Timestamp

    func getDays(time: Timestamp) -> Int

    func plusHours(time: Timestamp, hours: Int) -> Timestamp

    func startOfToday() -> Timestamp

}
