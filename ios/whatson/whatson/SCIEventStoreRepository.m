//
//  SCIEventStoreRepository.m
//  whatson
//
//  Created by Alex on 20/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "SCIEventStoreRepository.h"
#import <EventKit/EventKit.h>
#import "TimeCalculator.h"
#import "ArrayList.h"
#import "EventCalendarItem.h"
#import "Whatson-Swift.h"

@interface SCIEventStoreRepository()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateCalculator *calculator;
@property (nonatomic, strong) NSPredicate *predicate;

@end

@implementation SCIEventStoreRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
        _calculator = [[NSDateCalculator alloc] init];
        _predicate = [EventPredicates standardPredicates];
    }
    return self;
}

- (id<JavaUtilList>)getCalendarItemsWithSCTimestamp:(SCTimestamp *)nowTime
                                    withSCTimestamp:(SCTimestamp *)nextWeek
                                    withSCTimeOfDay:(SCTimeOfDay *)fivePm
                                    withSCTimeOfDay:(SCTimeOfDay *)elevenPm
                                withSCEventsService:(SCEventsService *)eventsService {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSDate *startTime =  [self.calculator date:nowTime];
    NSDate *endTime = [self.calculator date:nextWeek];
    NSPredicate *search = [eventStore predicateForEventsWithStartDate:startTime endDate:endTime calendars:nil];
    NSArray *array = [eventStore eventsMatchingPredicate:search];
    NSArray *filtered = [array filteredArrayUsingPredicate:self.predicate];
    id<JavaUtilList> items = [[JavaUtilArrayList alloc] init];
    for (EKEvent* item in filtered) {
        [items addWithId:[[SCEventCalendarItem alloc] initWithNSString:item.eventIdentifier
                                                          withNSString:item.title
                                                       withSCTimestamp:[self.calculator time:item.startDate]
                                                       withSCTimestamp:[self.calculator time:item.endDate]]];
    }
    return items;
}

@end
