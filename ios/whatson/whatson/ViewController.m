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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property EKEventStore *eventStore;
@property SCCalendarSource *calendarSource;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"EEE";
    self.eventStore = [[EKEventStore alloc] init];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.561 blue:0.486 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    self.title = @"What's On";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [self fetchEventsWithCompletionBlock:^(SCCalendarSource *source) {
                self.calendarSource = source;
                [self.tableView reloadData];
            }];
        }
    }];
}

- (void)fetchEventsWithCompletionBlock:(void (^)(SCCalendarSource *))completionBlock
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        SCIEventStoreRepository *repo = [[SCIEventStoreRepository alloc] init];
        NSDate *now = [[NSDate alloc] init];
        SCNSDateBasedTime *nowTime = [[SCNSDateBasedTime alloc] initWithNSDate:now];
        SCITimeRepository *timeRepo = [[SCITimeRepository alloc] init];
        SCEventsService *service = [[SCEventsService alloc] initWithSCTimeRepository:timeRepo withSCEventsRepository:repo];
        SCCalendarSource *source = [service getCalendarSourceWithInt:14 withSCTime:nowTime];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(source);
        });
    });
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell textLabel].text = [NSString stringWithFormat:@"%@: %@", [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(item.startTime / 1000)]], [item title]];
    return cell;
}

@end
