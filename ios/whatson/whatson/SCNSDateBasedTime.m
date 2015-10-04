//
//  SCNSDateBasedTime.m
//  whatson
//
//  Created by Alex on 19/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "SCNSDateBasedTime.h"

@interface SCNSDateBasedTime ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation SCNSDateBasedTime

- (instancetype) initWithNSDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        _date = date;
        _calendar = [NSCalendar currentCalendar];
    }
    return self;
}

- (id<SCTime>)plusDaysWithInt:(jint)days
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = days;
    NSDate *newDate =  [self.calendar dateByAddingComponents:components toDate:self.date options:0];
    return [[SCNSDateBasedTime alloc] initWithNSDate:newDate];
}

- (jint)daysSinceEpoch
{
    NSDateComponents *difference = [self.calendar components:NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:self.date options:0];
    return [difference day];
}

- (jlong)getMillis
{
    return [_date timeIntervalSince1970] * 1000;
}

- (id<SCTime>)plusHoursWithInt:(jint)hours
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = components.hour + hours;
    NSDate *newDate =  [self.calendar dateByAddingComponents:components toDate:self.date options:0];
    return [[SCNSDateBasedTime alloc] initWithNSDate:newDate];
}

+ (NSDate *)dateFromTime:(id<SCTime>)time
{
    NSTimeInterval seconds = [time getMillis] / 1000.0;
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}

@end
