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
#import "uk/co/amlcurran/social/EventRepositoryAccessor.h"
#import "uk/co/amlcurran/social/EventsService.h"
#import "SCITimeRepository.h"
#import "uk/co/amlcurran/social/CalendarItem.h"
#import "uk/co/amlcurran/social/CalendarSource.h"

@interface ViewController () <UITableViewDataSource>

@property EKEventStore *eventStore;
@property SCCalendarSource *calendarSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            SCIEventStoreRepository *repo = [[SCIEventStoreRepository alloc] init];
            NSDate *now = [[NSDate alloc] init];
            SCNSDateBasedTime *nowTime = [[SCNSDateBasedTime alloc] initWithNSDate:now];
            SCITimeRepository *timeRepo = [[SCITimeRepository alloc] init];
            SCEventsService *service = [[SCEventsService alloc] initWithSCTimeRepository:timeRepo withSCEventsRepository:repo];
            SCCalendarSource *source = [service getCalendarSourceWithInt:14 withSCTime:nowTime];
            self.calendarSource = source;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.calendarSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"day" forIndexPath:indexPath];
    id<SCCalendarItem> item = [self.calendarSource itemAtWithInt:indexPath.row];
    [cell textLabel].text = [item title];
    return cell;
}

@end
