//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/TimeRepository.java
//


#include "J2ObjC_source.h"
#include "Time.h"
#include "TimeRepository.h"

@interface SCTimeRepository : NSObject
@end

@implementation SCTimeRepository

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "endOfBorderTimeInMinutes", NULL, "I", 0x401, NULL, NULL },
    { "startOfBorderTimeInMinutes", NULL, "I", 0x401, NULL, NULL },
    { "startOfToday", NULL, "Luk.co.amlcurran.social.Time;", 0x401, NULL, NULL },
  };
  static const J2ObjcClassInfo _SCTimeRepository = { 2, "TimeRepository", "uk.co.amlcurran.social", NULL, 0x609, 3, methods, 0, NULL, 0, NULL, 0, NULL, NULL, NULL };
  return &_SCTimeRepository;
}

@end

J2OBJC_INTERFACE_TYPE_LITERAL_SOURCE(SCTimeRepository)