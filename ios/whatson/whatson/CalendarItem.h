//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/CalendarItem.java
//

#include "J2ObjC_header.h"

#pragma push_macro("CalendarItem_INCLUDE_ALL")
#ifdef CalendarItem_RESTRICT
#define CalendarItem_INCLUDE_ALL 0
#else
#define CalendarItem_INCLUDE_ALL 1
#endif
#undef CalendarItem_RESTRICT

#if !defined (SCCalendarItem_) && (CalendarItem_INCLUDE_ALL || defined(SCCalendarItem_INCLUDE))
#define SCCalendarItem_

@class SCTimestamp;

@protocol SCCalendarItem < NSObject, JavaObject >

- (NSString *)title;

- (SCTimestamp *)startTime;

- (SCTimestamp *)endTime;

- (jboolean)isEmpty;

@end

J2OBJC_EMPTY_STATIC_INIT(SCCalendarItem)

J2OBJC_TYPE_LITERAL_HEADER(SCCalendarItem)

#define UkCoAmlcurranSocialCalendarItem SCCalendarItem

#endif

#pragma pop_macro("CalendarItem_INCLUDE_ALL")
