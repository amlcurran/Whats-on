//
//  AppDelegate.m
//  whatson
//
//  Created by Alex on 18/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "AppDelegate.h"

@import EventKitUI;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSArray <UIApplicationShortcutItem *> *currentShortcuts = application.shortcutItems;
    if ([currentShortcuts count] == 0) {
        NSMutableArray <UIApplicationShortcutItem *> *updatedShortcuts = [currentShortcuts mutableCopy];
        UIMutableApplicationShortcutItem *newItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"new-tomorrow" localizedTitle:@"Add event tomorrow"];
        [updatedShortcuts addObject:newItem];
        [application setShortcutItems:updatedShortcuts];
    }
    
    if (launchOptions[UIApplicationLaunchOptionsShortcutItemKey]) {
        EKEventEditViewController *editController = [[EKEventEditViewController alloc] init];
        editController.eventStore = [EKEventStore new];
        [self.window.rootViewController presentViewController:editController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL succeeded))completionHandler
{
    EKEventEditViewController *editController = [[EKEventEditViewController alloc] init];
    editController.eventStore = [EKEventStore new];
    [self.window.rootViewController presentViewController:editController animated:YES completion:nil];
}

@end
