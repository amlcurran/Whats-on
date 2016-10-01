//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/Timestamp.java
//

#include "IOSClass.h"
#include "J2ObjC_source.h"
#include "TimeCalculator.h"
#include "Timestamp.h"
#include "javax/annotation/Nonnull.h"
#include "javax/annotation/meta/When.h"

#if __has_feature(nullability)
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wnullability-completeness"
#endif

@interface SCTimestamp () {
 @public
  id<SCTimeCalculator> timeCalculator_;
  jlong millis_;
}

@end

J2OBJC_FIELD_SETTER(SCTimestamp, timeCalculator_, id<SCTimeCalculator>)

#if __has_feature(nullability)
#pragma clang diagnostic pop
#endif

@implementation SCTimestamp

- (instancetype)initWithLong:(jlong)millis
        withSCTimeCalculator:(id<SCTimeCalculator>)timeCalculator {
  SCTimestamp_initWithLong_withSCTimeCalculator_(self, millis, timeCalculator);
  return self;
}

- (SCTimestamp * __nonnull)plusDaysWithInt:(jint)days {
  return [((id<SCTimeCalculator>) nil_chk(timeCalculator_)) plusDaysWithInt:days withSCTimestamp:self];
}

- (jint)daysSinceEpoch {
  return [((id<SCTimeCalculator>) nil_chk(timeCalculator_)) getDaysWithSCTimestamp:self];
}

- (jlong)getMillis {
  return millis_;
}

- (SCTimestamp * __nonnull)plusHoursWithInt:(jint)hours {
  return [((id<SCTimeCalculator>) nil_chk(timeCalculator_)) plusHoursWithSCTimestamp:self withInt:hours];
}

+ (IOSObjectArray *)__annotations_plusDaysWithInt_ {
  return [IOSObjectArray arrayWithObjects:(id[]) { [[JavaxAnnotationNonnull alloc] initWithWhen:JavaxAnnotationMetaWhen_get_ALWAYS()] } count:1 type:JavaLangAnnotationAnnotation_class_()];
}

+ (IOSObjectArray *)__annotations_plusHoursWithInt_ {
  return [IOSObjectArray arrayWithObjects:(id[]) { [[JavaxAnnotationNonnull alloc] initWithWhen:JavaxAnnotationMetaWhen_get_ALWAYS()] } count:1 type:JavaLangAnnotationAnnotation_class_()];
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "initWithLong:withSCTimeCalculator:", "Timestamp", NULL, 0x1, NULL, NULL },
    { "plusDaysWithInt:", "plusDays", "Luk.co.amlcurran.social.Timestamp;", 0x1, NULL, NULL },
    { "daysSinceEpoch", NULL, "I", 0x1, NULL, NULL },
    { "getMillis", NULL, "J", 0x1, NULL, NULL },
    { "plusHoursWithInt:", "plusHours", "Luk.co.amlcurran.social.Timestamp;", 0x1, NULL, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "timeCalculator_", NULL, 0x12, "Luk.co.amlcurran.social.TimeCalculator;", NULL, NULL, .constantValue.asLong = 0 },
    { "millis_", NULL, 0x12, "J", NULL, NULL, .constantValue.asLong = 0 },
  };
  static const J2ObjcClassInfo _SCTimestamp = { 2, "Timestamp", "uk.co.amlcurran.social", NULL, 0x1, 5, methods, 2, fields, 0, NULL, 0, NULL, NULL, NULL };
  return &_SCTimestamp;
}

@end

void SCTimestamp_initWithLong_withSCTimeCalculator_(SCTimestamp *self, jlong millis, id<SCTimeCalculator> timeCalculator) {
  NSObject_init(self);
  self->millis_ = millis;
  self->timeCalculator_ = timeCalculator;
}

SCTimestamp *new_SCTimestamp_initWithLong_withSCTimeCalculator_(jlong millis, id<SCTimeCalculator> timeCalculator) {
  SCTimestamp *self = [SCTimestamp alloc];
  SCTimestamp_initWithLong_withSCTimeCalculator_(self, millis, timeCalculator);
  return self;
}

SCTimestamp *create_SCTimestamp_initWithLong_withSCTimeCalculator_(jlong millis, id<SCTimeCalculator> timeCalculator) {
  return new_SCTimestamp_initWithLong_withSCTimeCalculator_(millis, timeCalculator);
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(SCTimestamp)
