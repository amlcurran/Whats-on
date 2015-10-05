//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EventRepositoryAccessor.java
//

#ifndef _EventRepositoryAccessor_H_
#define _EventRepositoryAccessor_H_

#include "J2ObjC_header.h"

@protocol SCTime;

@protocol SCEventRepositoryAccessor < NSObject, JavaObject >

- (NSString *)getTitle;

- (NSString *)getEventIdentifier;

- (jboolean)nextItem;

- (void)endAccess;

- (id<SCTime>)getStartTime;

- (id<SCTime>)getEndTime;

@end

J2OBJC_EMPTY_STATIC_INIT(SCEventRepositoryAccessor)

J2OBJC_TYPE_LITERAL_HEADER(SCEventRepositoryAccessor)

#define UkCoAmlcurranSocialEventRepositoryAccessor SCEventRepositoryAccessor

#endif // _EventRepositoryAccessor_H_
