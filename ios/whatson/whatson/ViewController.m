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
#import "EventCalendarItem.h"

@import EventKitUI;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, EKEventEditViewDelegate>

@property EKEventStore *eventStore;
@property SCCalendarSource *calendarSource;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) UIColor *dayColor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"EEE";
    self.eventStore = [[EKEventStore alloc] init];
    self.dayColor = [[UIColor blackColor] colorWithAlphaComponent:0.54];

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
    NSString *threeLetterDay = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(item.startTime / 1000)]];
    NSString *formatted = [NSString stringWithFormat:@"%@ - %@", threeLetterDay, [item title]];
    NSMutableAttributedString *coloured = [[NSMutableAttributedString alloc] initWithString:formatted];
    [coloured addAttribute:NSForegroundColorAttributeName value:self.dayColor range:NSMakeRange(0, 3)];
    [[cell textLabel] setAttributedText:coloured];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    id<SCCalendarItem> item = [self.calendarSource itemAtWithInt:indexPath.row];
    if ([item isEmpty]) {
        EKEvent *newEvent = [EKEvent eventWithEventStore:eventStore];
        EKEventEditViewController *editController = [[EKEventEditViewController alloc] init];
        editController.eventStore = eventStore;
        editController.event = newEvent;
        editController.editViewDelegate = self;
        [self.navigationController presentViewController:editController animated:YES completion:nil];
    } else {
        EKEvent *event = [eventStore eventWithIdentifier:((SCEventCalendarItem*) item).id__];
        EKEventViewController *eventDisplayer = [[EKEventViewController alloc] init];
        eventDisplayer.event = event;
        [self.navigationController pushViewController:eventDisplayer animated:YES];
    }
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
