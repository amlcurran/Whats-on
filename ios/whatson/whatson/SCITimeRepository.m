//
//  SCITimeRepository.m
//  whatson
//
//  Created by Alex on 19/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "SCITimeRepository.h"
#import "TimeOfDay.h"
#import "Whatson-Swift.h"

@interface SCITimeRepository()

@property (nonatomic, strong) NSDateCalculator *calculator;

@end

@implementation SCITimeRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calculator = [[NSDateCalculator alloc] init];
    }
    return self;
}

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

- (SCTime *)startOfToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:( NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *date = [calendar dateFromComponents:components];
    return [self.calculator time:date];
}

@end
