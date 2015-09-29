//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EventCalendarItem.java
//

#ifndef _SCEventCalendarItem_H_
#define _SCEventCalendarItem_H_

#include "CalendarItem.h"
#include "J2ObjC_header.h"

@protocol SCTime;

@interface SCEventCalendarItem : NSObject < SCCalendarItem >

#pragma mark Public

- (instancetype)initWithNSString:(NSString *)eventId
                    withNSString:(NSString *)title
                        withLong:(jlong)startTime
                      withSCTime:(id<SCTime>)time;

- (NSString *)id__;

- (jboolean)isEmpty;

- (jint)startDay;

- (jlong)startTime;

- (NSString *)title;

@end

J2OBJC_EMPTY_STATIC_INIT(SCEventCalendarItem)

FOUNDATION_EXPORT void SCEventCalendarItem_initWithNSString_withNSString_withLong_withSCTime_(SCEventCalendarItem *self, NSString *eventId, NSString *title, jlong startTime, id<SCTime> time);

FOUNDATION_EXPORT SCEventCalendarItem *new_SCEventCalendarItem_initWithNSString_withNSString_withLong_withSCTime_(NSString *eventId, NSString *title, jlong startTime, id<SCTime> time) NS_RETURNS_RETAINED;

J2OBJC_TYPE_LITERAL_HEADER(SCEventCalendarItem)

typedef SCEventCalendarItem UkCoAmlcurranSocialEventCalendarItem;

#endif // _SCEventCalendarItem_H_