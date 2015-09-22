//
//  SCIEventStoreRepository.h
//  whatson
//
//  Created by Alex on 20/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventsRepository.h"
#import "Time.h"

@interface SCIEventStoreRepository : NSObject<SCEventsRepository>

- (id<SCEventRepositoryAccessor>)queryEventsWithLong:(jlong)fivePm
                                            withLong:(jlong)elevenPm
                                          withSCTime:(id<SCTime>)searchStartTime
                                          withSCTime:(id<SCTime>)searchEndTime;
@end
