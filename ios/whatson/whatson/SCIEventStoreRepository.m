//
//  SCIEventStoreRepository.m
//  whatson
//
//  Created by Alex on 20/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "SCIEventStoreRepository.h"
#import <EventKit/EventKit.h>
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
    return @"hello!";
}

- (jlong)getDtStart
{
    return 0;
}

- (NSString *)getEventIdentifier
{
    return @"id";
}

- (jboolean)nextItem
{
    if (self.currentPosition < [self.events count]) {
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
    return nil;
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
    NSLog(@"%lu", [array count]);
    return [[SCIEKEventAccessor alloc] initWithEventItems:array];
}


@end
