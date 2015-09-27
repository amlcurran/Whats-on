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
#import "EventsService.h"
#import "SCITimeRepository.h"
#import "CalendarItem.h"
#import "CalendarSource.h"

@interface ViewController () <UITableViewDataSource>

@property EKEventStore *eventStore;
@property SCCalendarSource *calendarSource;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"EEE";
    
    self.title = @"What's On";
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
    [cell textLabel].text = [NSString stringWithFormat:@"%@: %@", [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(item.startTime / 1000)]], [item title]];
    return cell;
}

@end
