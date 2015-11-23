//
//  NSDateCalculator.swift
//  whatson
//
//  Created by Alex on 22/11/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

import Foundation

public class NSDateCalculator : NSObject, SCTimeCalculator {
    
    let calendar : NSCalendar;
    private let noOptions = NSCalendarOptions(rawValue: 0);
    
    override init() {
        calendar = NSCalendar.currentCalendar();
        super.init();
    }
    
    func now() -> SCTime {
        let millis = jlong(NSDate().timeIntervalSince1970 * 1000);
        return SCTime(long: millis, withSCTimeCalculator: self);
    }
    
    @objc public func plusDaysWithInt(days: jint, withSCTime time: SCTime!) -> SCTime! {
        let components = NSDateComponents();
        components.day = Int(days);
        let timeAsDate = date(time);
        let newDate = calendar.dateByAddingComponents(components, toDate: timeAsDate, options: noOptions);
        return SCTime(long: jlong(newDate!.timeIntervalSince1970 * 1000), withSCTimeCalculator: self);
    }
    
    @objc public func getDaysWithSCTime(time: SCTime!) -> jint {
        let difference = self.calendar.components(.Day, fromDate: NSDate(timeIntervalSince1970: 0), toDate: date(time), options: noOptions);
        return jint(difference.day);
    }
    
    @objc public func plusHoursWithSCTime(time: SCTime!, withInt hours: jint) -> SCTime! {
        let components = NSDateComponents();
        components.hour = Int(hours);
        let timeAsDate = date(time);
        let newDate = calendar.dateByAddingComponents(components, toDate: timeAsDate, options: noOptions);
        return SCTime(long: jlong(newDate!.timeIntervalSince1970 * 1000), withSCTimeCalculator: self);
    }
    
    internal func date(time: SCTime) -> NSDate {
        return NSDate(timeIntervalSince1970: (Double(time.getMillis()) / 1000.0));
    }
    
    internal func time(date: NSDate) -> SCTime {
        return SCTime(long: jlong(date.timeIntervalSince1970 * 1000), withSCTimeCalculator: self);
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