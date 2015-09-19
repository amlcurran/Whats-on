//
//  ViewController.m
//  whatson
//
//  Created by Alex on 18/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "ViewController.h"
#import <EventKit/EventKit.h>

@interface ViewController ()

@property EKEventStore *eventStore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Go nuts");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
