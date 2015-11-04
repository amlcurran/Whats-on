//
//  SCITimeRepository.m
//  whatson
//
//  Created by Alex on 19/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "SCITimeRepository.h"
#import "SCNSDateBasedTime.h"
#import "TimeOfDay.h"

@implementation SCITimeRepository

- (jint)endOfBorderTimeInMinutes
{
    return 23 * 60;
}

- (jint)startOfBorderTimeInMinutes
{
    return 17 * 60;
}

- (SCTimeOfDay *)borderTimeEnd
{
    return [SCTimeOfDay fromHoursWithInt:23];
}

- (SCTimeOfDay *)borderTimeStart
{
    return [SCTimeOfDay fromHoursWithInt:17];
}

- (id<SCTime>)startOfToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:( NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *date = [calendar dateFromComponents:components];
    return [[SCNSDateBasedTime alloc] initWithNSDate:date];
}

@end
