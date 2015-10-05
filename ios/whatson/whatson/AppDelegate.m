//
//  AppDelegate.m
//  whatson
//
//  Created by Alex on 18/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "AppDelegate.h"
#import <EventKit/EventKit.h>

@import EventKitUI;

@interface AppDelegate () <EKEventEditViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSMutableArray <UIApplicationShortcutItem *> *updatedShortcuts = [[NSMutableArray alloc] init];
    
    UIMutableApplicationShortcutItem *newItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"new-tomorrow" localizedTitle:@"Add event tomorrow"];
    [newItem setIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd]];
    UIMutableApplicationShortcutItem *onToday = [[UIMutableApplicationShortcutItem alloc] initWithType:@"on-today" localizedTitle:@"On today"];
    [onToday setIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeDate]];
    
    [updatedShortcuts addObject:onToday];
    [updatedShortcuts addObject:newItem];
    
    [application setShortcutItems:updatedShortcuts];
    
    UIApplicationShortcutItem *item = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
    if (item) {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        return ![self handleShortcutItem:item];
    }
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL succeeded))completionHandler
{
    [self handleShortcutItem:shortcutItem];
}

- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *)item
{
    if ([item.type isEqualToString:@"new-tomorrow"]) {
        EKEvent *event = [EKEvent eventWithEventStore:[[EKEventStore alloc] init]];
        NSDate *date = [[NSCalendar currentCalendar] dateBySettingHour:17 minute:0 second:0 ofDate:[NSDate new] options:0];
        event.startDate = date;
        EKEventEditViewController *editController = [[EKEventEditViewController alloc] init];
        editController.editViewDelegate = self;
        editController.eventStore = [EKEventStore new];
        [self.window.rootViewController presentViewController:editController animated:YES completion:nil];
        return YES;
    } else if ([item.type isEqualToString:@"on-today"]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"You've not implemented this yet" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }];
        [controller addAction:action];
        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
        return NO;
    }
    return NO;
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
