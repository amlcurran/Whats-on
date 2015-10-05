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
    NSDate *date = [self currentEvent].startDate;
    return [[SCNSDateBasedTime alloc] initWithNSDate:date];
}

- (id<SCTime>)getEndTime
{
    NSDate *date = [self currentEvent].endDate;
    return [[SCNSDateBasedTime alloc] initWithNSDate:date];
}

- (EKEvent *)currentEvent
{
    return ((EKEvent *) [[self events] objectAtIndex:self.currentPosition]);
}

@end

@interface SCIEventStoreRepository()

@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation SCIEventStoreRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
    }
    return self;
}

- (id<SCEventRepositoryAccessor>)queryEventsWithLong:(jlong)fivePm
                                            withLong:(jlong)elevenPm
                                          withSCTime:(id<SCTime>)searchStartTime
                                          withSCTime:(id<SCTime>)searchEndTime
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSDate *startTime = [SCNSDateBasedTime dateFromTime:searchStartTime];
    NSDate *endTime = [SCNSDateBasedTime dateFromTime:searchEndTime];
    NSPredicate *search = [eventStore predicateForEventsWithStartDate:startTime endDate:endTime calendars:nil];
    NSArray *array = [eventStore eventsMatchingPredicate:search];
    __block NSCalendar *calendar = self.calendar;
    NSArray *filtered = [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        EKEvent *event = (EKEvent *) evaluatedObject;
        NSDateComponents *endComponents = [calendar components:NSCalendarUnitHour fromDate:event.endDate];
        endComponents.timeZone = [NSTimeZone defaultTimeZone];
        bool endsBefore = endComponents.hour <= 17;
        NSDateComponents *startComponents = [calendar components:NSCalendarUnitHour fromDate:event.startDate];
        startComponents.timeZone = [NSTimeZone defaultTimeZone];
        bool startsAfter = startComponents.hour > 23;
        return !(endsBefore || startsAfter) && event.allDay == false;
    }]];
    return [[SCIEKEventAccessor alloc] initWithEventItems:filtered];
}


@end
