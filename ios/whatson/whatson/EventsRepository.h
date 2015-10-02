//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EventsRepository.java
//

#ifndef _EventsRepository_H_
#define _EventsRepository_H_

#include "J2ObjC_header.h"

@protocol SCEventRepositoryAccessor;
@protocol SCTime;

@protocol SCEventsRepository < NSObject, JavaObject >

- (id<SCEventRepositoryAccessor>)queryEventsWithLong:(jlong)fivePm
                                            withLong:(jlong)elevenPm
                                          withSCTime:(id<SCTime>)searchStartTime
                                          withSCTime:(id<SCTime>)searchEndTime;

@end

J2OBJC_EMPTY_STATIC_INIT(SCEventsRepository)

J2OBJC_TYPE_LITERAL_HEADER(SCEventsRepository)

#define UkCoAmlcurranSocialEventsRepository SCEventsRepository

#endif // _EventsRepository_H_
