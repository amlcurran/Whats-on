//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EmptyCalendarItem.java
//

#ifndef _EmptyCalendarItem_H_
#define _EmptyCalendarItem_H_

#include "CalendarItem.h"
#include "J2ObjC_header.h"

@class SCTime;

@interface SCEmptyCalendarItem : NSObject < SCCalendarItem >

#pragma mark Public

- (instancetype)initWithSCTime:(SCTime *)startTime
                    withSCTime:(SCTime *)endTime;

- (SCTime *)endTime;

- (jboolean)isEmpty;

- (SCTime *)startTime;

- (NSString *)title;

@end

J2OBJC_EMPTY_STATIC_INIT(SCEmptyCalendarItem)

FOUNDATION_EXPORT void SCEmptyCalendarItem_initWithSCTime_withSCTime_(SCEmptyCalendarItem *self, SCTime *startTime, SCTime *endTime);

FOUNDATION_EXPORT SCEmptyCalendarItem *new_SCEmptyCalendarItem_initWithSCTime_withSCTime_(SCTime *startTime, SCTime *endTime) NS_RETURNS_RETAINED;

J2OBJC_TYPE_LITERAL_HEADER(SCEmptyCalendarItem)

@compatibility_alias UkCoAmlcurranSocialEmptyCalendarItem SCEmptyCalendarItem;

#endif // _EmptyCalendarItem_H_
