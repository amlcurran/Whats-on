//
//  NSDate+Time.swift
//  whatson
//
//  Created by Alex on 27/02/2016.
//  Copyright © 2016 Alex Curran. All rights reserved.
//

import UIKit

extension NSDate {
    
    static func dateFromTime(time: SCTime) -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(time.getMillis() / 1000))
    }

}
