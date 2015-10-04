//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EventsService.java
//

#ifndef _EventsService_H_
#define _EventsService_H_

#include "J2ObjC_header.h"

@class SCCalendarSource;
@protocol SCEventsRepository;
@protocol SCTime;
@protocol SCTimeRepository;

@interface SCEventsService : NSObject

#pragma mark Public

- (instancetype)initWithSCTimeRepository:(id<SCTimeRepository>)dateCreator
                  withSCEventsRepository:(id<SCEventsRepository>)eventsRepository;

- (SCCalendarSource *)getCalendarSourceWithInt:(jint)numberOfDays
                                    withSCTime:(id<SCTime>)now;

@end

J2OBJC_EMPTY_STATIC_INIT(SCEventsService)

FOUNDATION_EXPORT void SCEventsService_initWithSCTimeRepository_withSCEventsRepository_(SCEventsService *self, id<SCTimeRepository> dateCreator, id<SCEventsRepository> eventsRepository);

FOUNDATION_EXPORT SCEventsService *new_SCEventsService_initWithSCTimeRepository_withSCEventsRepository_(id<SCTimeRepository> dateCreator, id<SCEventsRepository> eventsRepository) NS_RETURNS_RETAINED;

J2OBJC_TYPE_LITERAL_HEADER(SCEventsService)

@compatibility_alias UkCoAmlcurranSocialEventsService SCEventsService;

#endif // _EventsService_H_
