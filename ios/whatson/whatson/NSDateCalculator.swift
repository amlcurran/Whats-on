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
    private let noOptions = Calendar.Options(rawValue: 0);
    
    override init() {
        calendar = Calendar.current();
        super.init();
    }
    
    func now() -> SCTime {
        let millis = jlong(Date().timeIntervalSince1970 * 1000);
        return SCTime(long: millis, with: self);
    }
    
    @objc public func plusDays(with days: jint, with time: SCTime!) -> SCTime! {
        var components = DateComponents();
        components.day = Int(days);
        let timeAsDate = date(time);
        let newDate = calendar.date(byAdding: components, to: timeAsDate, options: noOptions);
        return SCTime(long: jlong(newDate!.timeIntervalSince1970 * 1000), with: self);
    }
    
    @objc public func getDaysWith(_ time: SCTime!) -> jint {
        let difference = self.calendar.components(.day, from: Date(timeIntervalSince1970: 0), to: date(time), options: noOptions);
        return jint(difference.day!);
    }
    
    @objc public func plusHours(with time: SCTime!, with hours: jint) -> SCTime! {
        var components = DateComponents();
        components.hour = Int(hours);
        let timeAsDate = date(time);
        let newDate = calendar.date(byAdding: components, to: timeAsDate, options: noOptions);
        return SCTime(long: jlong(newDate!.timeIntervalSince1970 * 1000), with: self);
    }
    
    internal func date(_ time: SCTime) -> Date {
        return Date(timeIntervalSince1970: (Double(time.getMillis()) / 1000.0));
    }
    
    internal func time(_ date: Date) -> SCTime {
        return SCTime(long: jlong(date.timeIntervalSince1970 * 1000), with: self);
    }
    
    /*
    
    - (NSString *)description
    {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:self.date];
    }
    
    + (NSDate *)dateFromTime:(id<SCTime>)time
    {
    NSTimeInterval seconds = [time getMillis] / 1000.0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginning = [NSDate dateWithTimeIntervalSince1970:0];
    return [calendar dateByAddingUnit:NSCalendarUnitSecond value:seconds toDate:beginning options:0];
    }
    
    */
    
}
