//
//  SCNSDateBasedTime.h
//  whatson
//
//  Created by Alex on 19/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCTime.h"

@interface SCNSDateBasedTime : NSObject <SCTime>

- (instancetype)initWithNSDate:(NSDate *)date;

@end
