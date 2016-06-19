//
//  NSDate+Time.swift
//  whatson
//
//  Created by Alex on 27/02/2016.
//  Copyright © 2016 Alex Curran. All rights reserved.
//

import UIKit

extension Date {
    
    static func dateFromTime(_ time: SCTime) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(time.getMillis() / 1000))
    }

}
