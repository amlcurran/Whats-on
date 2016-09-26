//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/CalendarSource.java
//

#include "J2ObjC_header.h"

#pragma push_macro("CalendarSource_INCLUDE_ALL")
#ifdef CalendarSource_RESTRICT
#define CalendarSource_INCLUDE_ALL 0
#else
#define CalendarSource_INCLUDE_ALL 1
#endif
#undef CalendarSource_RESTRICT

#if !defined (SCCalendarSource_) && (CalendarSource_INCLUDE_ALL || defined(SCCalendarSource_INCLUDE))
#define SCCalendarSource_

@class SCCalendarSlot;
@class UkCoAmlcurranSocialCoreSparseArray;
@protocol SCCalendarItem;
@protocol SCTimeRepository;

@interface SCCalendarSource : NSObject

#pragma mark Public

- (instancetype)initWithSCTimeRepository:(id<SCTimeRepository>)timeRepository
  withUkCoAmlcurranSocialCoreSparseArray:(UkCoAmlcurranSocialCoreSparseArray *)calendarItems
                                 withInt:(jint)daysSize;

- (jint)count;

- (jboolean)isEmptySlotWithInt:(jint)position;

- (id<SCCalendarItem>)itemAtWithInt:(jint)position;

- (SCCalendarSlot *)slotAtWithInt:(jint)position;

@end

J2OBJC_EMPTY_STATIC_INIT(SCCalendarSource)

FOUNDATION_EXPORT void SCCalendarSource_initWithSCTimeRepository_withUkCoAmlcurranSocialCoreSparseArray_withInt_(SCCalendarSource *self, id<SCTimeRepository> timeRepository, UkCoAmlcurranSocialCoreSparseArray *calendarItems, jint daysSize);

FOUNDATION_EXPORT SCCalendarSource *new_SCCalendarSource_initWithSCTimeRepository_withUkCoAmlcurranSocialCoreSparseArray_withInt_(id<SCTimeRepository> timeRepository, UkCoAmlcurranSocialCoreSparseArray *calendarItems, jint daysSize) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT SCCalendarSource *create_SCCalendarSource_initWithSCTimeRepository_withUkCoAmlcurranSocialCoreSparseArray_withInt_(id<SCTimeRepository> timeRepository, UkCoAmlcurranSocialCoreSparseArray *calendarItems, jint daysSize);

J2OBJC_TYPE_LITERAL_HEADER(SCCalendarSource)

@compatibility_alias UkCoAmlcurranSocialCalendarSource SCCalendarSource;

#endif

#pragma pop_macro("CalendarSource_INCLUDE_ALL")
