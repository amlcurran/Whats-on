//
//  NSDateCalculator.swift
//  whatson
//
//  Created by Alex on 22/11/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

import Foundation

public class NSDateCalculator : NSObject, SCTimeCalculator {
    
    let calendar : Calendar;
    
    override init() {
        calendar = Calendar.current;
        super.init();
    }
    
    func now() -> SCTimestamp {
        let millis = jlong(Date().timeIntervalSince1970 * 1000);
        return SCTimestamp(long: millis, with: self);
    }
    
    @objc public func plusDays(with days: jint, with time: SCTimestamp!) -> SCTimestamp {
        var components = DateComponents();
        components.day = Int(days);
        let timeAsDate = date(time);
        let newDate = calendar.date(byAdding: components, to: timeAsDate);
        return SCTimestamp(long: jlong(newDate!.timeIntervalSince1970 * 1000), with: self);
    }
    
    @objc public func getDaysWith(_ time: SCTimestamp!) -> jint {
        let difference = self.calendar.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: date(time));
        return jint(difference.day!);
    }
    
    @objc public func plusHours(with time: SCTimestamp!, with hours: jint) -> SCTimestamp {
        var components = DateComponents();
        components.hour = Int(hours);
        let timeAsDate = date(time);
        let newDate = calendar.date(byAdding: components, to: timeAsDate);
        return SCTimestamp(long: jlong(newDate!.timeIntervalSince1970 * 1000), with: self);
    }
    
    internal func date(_ time: SCTimestamp) -> Date {
        return Date(timeIntervalSince1970: (Double(time.getMillis()) / 1000.0));
    }
    
    internal func time(_ date: NSDate) -> SCTimestamp {
        return SCTimestamp(long: jlong(date.timeIntervalSince1970 * 1000), with: self);
    }
    
}
