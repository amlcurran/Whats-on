//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/CalendarSource.java
//

#include "CalendarItem.h"
#include "CalendarSource.h"
#include "EmptyCalendarItem.h"
#include "J2ObjC_source.h"
#include "SparseArray.h"
#include "SCTime.h"

@interface SCCalendarSource () {
 @public
  UkCoAmlcurranSocialCoreSparseArray *calendarItems_;
  jint daysSize_;
  id<SCTime> now_;
}

@end

J2OBJC_FIELD_SETTER(SCCalendarSource, calendarItems_, UkCoAmlcurranSocialCoreSparseArray *)
J2OBJC_FIELD_SETTER(SCCalendarSource, now_, id<SCTime>)

@implementation SCCalendarSource

- (instancetype)initWithUkCoAmlcurranSocialCoreSparseArray:(UkCoAmlcurranSocialCoreSparseArray *)calendarItems
                                                   withInt:(jint)daysSize
                                                withSCTime:(id<SCTime>)now {
  SCCalendarSource_initWithUkCoAmlcurranSocialCoreSparseArray_withInt_withSCTime_(self, calendarItems, daysSize, now);
  return self;
}

- (jint)count {
  return daysSize_;
}

- (id<SCCalendarItem>)itemAtWithInt:(jint)position {
  id<SCCalendarItem> calendarItem = [((UkCoAmlcurranSocialCoreSparseArray *) nil_chk(calendarItems_)) getWithInt:position];
  if (calendarItem == nil) {
    return new_SCEmptyCalendarItem_initWithInt_withSCTime_(position, [((id<SCTime>) nil_chk(now_)) plusDaysWithInt:position]);
  }
  return calendarItem;
}

- (jboolean)isEmptyAtWithInt:(jint)position {
  return [((UkCoAmlcurranSocialCoreSparseArray *) nil_chk(calendarItems_)) getWithInt:position] == nil;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "initWithUkCoAmlcurranSocialCoreSparseArray:withInt:withSCTime:", "CalendarSource", NULL, 0x1, NULL, NULL },
    { "count", NULL, "I", 0x1, NULL, NULL },
    { "itemAtWithInt:", "itemAt", "Luk.co.amlcurran.social.CalendarItem;", 0x1, NULL, NULL },
    { "isEmptyAtWithInt:", "isEmptyAt", "Z", 0x1, NULL, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "calendarItems_", NULL, 0x12, "Luk.co.amlcurran.social.core.SparseArray;", NULL, "Luk/co/amlcurran/social/core/SparseArray<Luk/co/amlcurran/social/CalendarItem;>;", .constantValue.asLong = 0 },
    { "daysSize_", NULL, 0x12, "I", NULL, NULL, .constantValue.asLong = 0 },
    { "now_", NULL, 0x12, "Luk.co.amlcurran.social.Time;", NULL, NULL, .constantValue.asLong = 0 },
  };
  static const J2ObjcClassInfo _SCCalendarSource = { 2, "CalendarSource", "uk.co.amlcurran.social", NULL, 0x0, 4, methods, 3, fields, 0, NULL, 0, NULL, NULL, NULL };
  return &_SCCalendarSource;
}

@end

void SCCalendarSource_initWithUkCoAmlcurranSocialCoreSparseArray_withInt_withSCTime_(SCCalendarSource *self, UkCoAmlcurranSocialCoreSparseArray *calendarItems, jint daysSize, id<SCTime> now) {
  (void) NSObject_init(self);
  self->calendarItems_ = calendarItems;
  self->daysSize_ = daysSize;
  self->now_ = now;
}

SCCalendarSource *new_SCCalendarSource_initWithUkCoAmlcurranSocialCoreSparseArray_withInt_withSCTime_(UkCoAmlcurranSocialCoreSparseArray *calendarItems, jint daysSize, id<SCTime> now) {
  SCCalendarSource *self = [SCCalendarSource alloc];
  SCCalendarSource_initWithUkCoAmlcurranSocialCoreSparseArray_withInt_withSCTime_(self, calendarItems, daysSize, now);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(SCCalendarSource)
