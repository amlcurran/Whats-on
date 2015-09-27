//
//  SCIEventStoreRepository.m
//  whatson
//
//  Created by Alex on 20/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "SCIEventStoreRepository.h"
#import <EventKit/EventKit.h>
#import "SCNSDateBasedTime.h"
#import "EventRepositoryAccessor.h"

@interface SCIEKEventAccessor : NSObject<SCEventRepositoryAccessor>

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, assign) int currentPosition;

- (instancetype)initWithEventItems:(NSArray *)items;

@end

@implementation SCIEKEventAccessor

- (instancetype)initWithEventItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _events = items;
    }
    return self;
}

- (NSString *)getTitle
{
    return [self currentEvent].title;
}

- (jlong)getDtStart
{
    return [[self currentEvent].startDate timeIntervalSince1970] * 1000;
}

- (NSString *)getEventIdentifier
{
    return [self currentEvent].eventIdentifier;
}

- (jboolean)nextItem
{
    if ([self.events count] == 0) {
        return false;
    }
    if (self.currentPosition < [self.events count] - 1) {
        self.currentPosition++;
        return true;
    }
    return false;
}

- (void)endAccess
{
    
}

- (id<SCTime>)getStartTime
{
    return [[SCNSDateBasedTime alloc] initWithNSDate:[self currentEvent].startDate];
}

- (EKEvent *)currentEvent
{
    return ((EKEvent *) [[self events] objectAtIndex:self.currentPosition]);
}

@end

@implementation SCIEventStoreRepository

- (id<SCEventRepositoryAccessor>)queryEventsWithLong:(jlong)fivePm
                                            withLong:(jlong)elevenPm
                                          withSCTime:(id<SCTime>)searchStartTime
                                          withSCTime:(id<SCTime>)searchEndTime
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSDate *startTime = [[NSDate alloc] initWithTimeIntervalSince1970:([searchStartTime getMillis] / 1000)];
    NSDate *endTime = [[NSDate alloc] initWithTimeIntervalSince1970:([searchEndTime getMillis] / 1000)];
    NSPredicate *search = [eventStore predicateForEventsWithStartDate:startTime endDate:endTime calendars:nil];
    NSArray *array = [eventStore eventsMatchingPredicate:search];
    return [[SCIEKEventAccessor alloc] initWithEventItems:array];
}


@end
