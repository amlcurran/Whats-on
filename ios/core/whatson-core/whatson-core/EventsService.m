//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EventsService.java
//

#include "CalendarItem.h"
#include "CalendarSource.h"
#include "EventCalendarItem.h"
#include "EventRepositoryAccessor.h"
#include "EventsRepository.h"
#include "EventsService.h"
#include "J2ObjC_source.h"
#include "SparseArray.h"
#include "SCTime.h"
#include "TimeRepository.h"
#include "java/util/ArrayList.h"
#include "java/util/List.h"

@interface SCEventsService () {
 @public
  id<SCTimeRepository> timeRepository_;
  id<SCEventsRepository> eventsRepository_;
}

@end

J2OBJC_FIELD_SETTER(SCEventsService, timeRepository_, id<SCTimeRepository>)
J2OBJC_FIELD_SETTER(SCEventsService, eventsRepository_, id<SCEventsRepository>)

@implementation SCEventsService

- (instancetype)initWithSCTimeRepository:(id<SCTimeRepository>)dateCreator
                  withSCEventsRepository:(id<SCEventsRepository>)eventsRepository {
  SCEventsService_initWithSCTimeRepository_withSCEventsRepository_(self, dateCreator, eventsRepository);
  return self;
}

- (SCCalendarSource *)getCalendarSourceWithInt:(jint)numberOfDays
                                    withSCTime:(id<SCTime>)now {
  id<SCTime> nowTime = [((id<SCTimeRepository>) nil_chk(timeRepository_)) startOfToday];
  id<SCTime> nextWeek = [((id<SCTime>) nil_chk(nowTime)) plusDaysWithInt:numberOfDays];
  jlong fivePm = [timeRepository_ startOfBorderTimeInMinutes];
  jlong elevenPm = [timeRepository_ endOfBorderTimeInMinutes];
  id<SCEventRepositoryAccessor> accessor = [((id<SCEventsRepository>) nil_chk(eventsRepository_)) queryEventsWithLong:fivePm withLong:elevenPm withSCTime:nowTime withSCTime:nextWeek];
  id<JavaUtilList> calendarItems = new_JavaUtilArrayList_init();
  while ([((id<SCEventRepositoryAccessor>) nil_chk(accessor)) nextItem]) {
    NSString *title = [accessor getTitle];
    NSString *eventId = [accessor getEventIdentifier];
    id<SCTime> time = [accessor getStartTime];
    [calendarItems addWithId:new_SCEventCalendarItem_initWithNSString_withNSString_withSCTime_(eventId, title, time)];
  }
  UkCoAmlcurranSocialCoreSparseArray *itemArray = new_UkCoAmlcurranSocialCoreSparseArray_initWithInt_(numberOfDays);
  jint epochToNow = [((id<SCTime>) nil_chk(now)) daysSinceEpoch];
  for (id<SCCalendarItem> __strong item in calendarItems) {
    [itemArray putWithInt:[((id<SCTime>) nil_chk([((id<SCCalendarItem>) nil_chk(item)) startTime])) daysSinceEpoch] - epochToNow withId:item];
  }
  SCCalendarSource *calendarSource = new_SCCalendarSource_initWithSCTimeRepository_withUkCoAmlcurranSocialCoreSparseArray_withInt_withSCTime_(timeRepository_, itemArray, numberOfDays, now);
  [accessor endAccess];
  return calendarSource;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "initWithSCTimeRepository:withSCEventsRepository:", "EventsService", NULL, 0x1, NULL, NULL },
    { "getCalendarSourceWithInt:withSCTime:", "getCalendarSource", "Luk.co.amlcurran.social.CalendarSource;", 0x1, NULL, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "timeRepository_", NULL, 0x12, "Luk.co.amlcurran.social.TimeRepository;", NULL, NULL, .constantValue.asLong = 0 },
    { "eventsRepository_", NULL, 0x12, "Luk.co.amlcurran.social.EventsRepository;", NULL, NULL, .constantValue.asLong = 0 },
  };
  static const J2ObjcClassInfo _SCEventsService = { 2, "EventsService", "uk.co.amlcurran.social", NULL, 0x1, 2, methods, 2, fields, 0, NULL, 0, NULL, NULL, NULL };
  return &_SCEventsService;
}

@end

void SCEventsService_initWithSCTimeRepository_withSCEventsRepository_(SCEventsService *self, id<SCTimeRepository> dateCreator, id<SCEventsRepository> eventsRepository) {
  (void) NSObject_init(self);
  self->eventsRepository_ = eventsRepository;
  self->timeRepository_ = dateCreator;
}

SCEventsService *new_SCEventsService_initWithSCTimeRepository_withSCEventsRepository_(id<SCTimeRepository> dateCreator, id<SCEventsRepository> eventsRepository) {
  SCEventsService *self = [SCEventsService alloc];
  SCEventsService_initWithSCTimeRepository_withSCEventsRepository_(self, dateCreator, eventsRepository);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(SCEventsService)
