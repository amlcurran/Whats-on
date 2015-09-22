//
//  ViewController.m
//  whatson
//
//  Created by Alex on 18/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "ViewController.h"
#import <EventKit/EventKit.h>
#import "SCIEventStoreRepository.h"
#import "SCNSDateBasedTime.h"
#import "EventRepositoryAccessor.h"

@interface ViewController ()

@property EKEventStore *eventStore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            SCIEventStoreRepository *repo = [[SCIEventStoreRepository alloc] init];
            NSDate *now = [[NSDate alloc] init];
            NSDate *twoWeeksTime = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:14 toDate:now options:0];
            SCNSDateBasedTime *nowTime = [[SCNSDateBasedTime alloc] initWithNSDate:now];
            id<SCEventRepositoryAccessor> accessor = [repo queryEventsWithLong:0 withLong:0 withSCTime:nowTime withSCTime:[[SCNSDateBasedTime alloc] initWithNSDate:twoWeeksTime]];
            while ([accessor nextItem]) {
                NSLog(@"Something!");
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
