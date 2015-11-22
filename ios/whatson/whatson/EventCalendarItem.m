//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EventCalendarItem.java
//

#include "EventCalendarItem.h"
#include "J2ObjC_source.h"
#include "SCTime.h"

@interface SCEventCalendarItem () {
 @public
  NSString *eventId_;
  NSString *title_;
  SCTime *start_;
  SCTime *endTime_;
}

@end

J2OBJC_FIELD_SETTER(SCEventCalendarItem, eventId_, NSString *)
J2OBJC_FIELD_SETTER(SCEventCalendarItem, title_, NSString *)
J2OBJC_FIELD_SETTER(SCEventCalendarItem, start_, SCTime *)
J2OBJC_FIELD_SETTER(SCEventCalendarItem, endTime_, SCTime *)

@implementation SCEventCalendarItem

- (instancetype)initWithNSString:(NSString *)eventId
                    withNSString:(NSString *)title
                      withSCTime:(SCTime *)time
                      withSCTime:(SCTime *)endTime {
  SCEventCalendarItem_initWithNSString_withNSString_withSCTime_withSCTime_(self, eventId, title, time, endTime);
  return self;
}

- (NSString *)id__ {
  return eventId_;
}

- (NSString *)title {
  return title_;
}

- (SCTime *)startTime {
  return start_;
}

- (SCTime *)endTime {
  return endTime_;
}

- (jboolean)isEmpty {
  return false;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "initWithNSString:withNSString:withSCTime:withSCTime:", "EventCalendarItem", NULL, 0x1, NULL, NULL },
    { "id__", "id", "Ljava.lang.String;", 0x1, NULL, NULL },
    { "title", NULL, "Ljava.lang.String;", 0x1, NULL, NULL },
    { "startTime", NULL, "Luk.co.amlcurran.social.Time;", 0x1, NULL, NULL },
    { "endTime", NULL, "Luk.co.amlcurran.social.Time;", 0x1, NULL, NULL },
    { "isEmpty", NULL, "Z", 0x1, NULL, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "eventId_", NULL, 0x12, "Ljava.lang.String;", NULL, NULL, .constantValue.asLong = 0 },
    { "title_", NULL, 0x12, "Ljava.lang.String;", NULL, NULL, .constantValue.asLong = 0 },
    { "start_", NULL, 0x12, "Luk.co.amlcurran.social.Time;", NULL, NULL, .constantValue.asLong = 0 },
    { "endTime_", NULL, 0x12, "Luk.co.amlcurran.social.Time;", NULL, NULL, .constantValue.asLong = 0 },
  };
  static const J2ObjcClassInfo _SCEventCalendarItem = { 2, "EventCalendarItem", "uk.co.amlcurran.social", NULL, 0x0, 6, methods, 4, fields, 0, NULL, 0, NULL, NULL, NULL };
  return &_SCEventCalendarItem;
}

@end

void SCEventCalendarItem_initWithNSString_withNSString_withSCTime_withSCTime_(SCEventCalendarItem *self, NSString *eventId, NSString *title, SCTime *time, SCTime *endTime) {
  (void) NSObject_init(self);
  self->eventId_ = eventId;
  self->title_ = title;
  self->start_ = time;
  self->endTime_ = endTime;
}

SCEventCalendarItem *new_SCEventCalendarItem_initWithNSString_withNSString_withSCTime_withSCTime_(NSString *eventId, NSString *title, SCTime *time, SCTime *endTime) {
  SCEventCalendarItem *self = [SCEventCalendarItem alloc];
  SCEventCalendarItem_initWithNSString_withNSString_withSCTime_withSCTime_(self, eventId, title, time, endTime);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(SCEventCalendarItem)
