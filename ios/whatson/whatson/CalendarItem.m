//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/CalendarItem.java
//


#include "CalendarItem.h"
#include "J2ObjC_source.h"
#include "Time.h"

@interface SCCalendarItem : NSObject
@end

@implementation SCCalendarItem

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "title", NULL, "Ljava.lang.String;", 0x401, NULL, NULL },
    { "startDay", NULL, "I", 0x401, NULL, NULL },
    { "startTime", NULL, "Luk.co.amlcurran.social.Time;", 0x401, NULL, NULL },
    { "isEmpty", NULL, "Z", 0x401, NULL, NULL },
  };
  static const J2ObjcClassInfo _SCCalendarItem = { 2, "CalendarItem", "uk.co.amlcurran.social", NULL, 0x609, 4, methods, 0, NULL, 0, NULL, 0, NULL, NULL, NULL };
  return &_SCCalendarItem;
}

@end

J2OBJC_INTERFACE_TYPE_LITERAL_SOURCE(SCCalendarItem)
