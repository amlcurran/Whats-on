//
//  ObjCTime.m
//  whatson
//
//  Created by Alex on 18/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "ObjCTime.h"

@implementation ObjCTime

- (id<UkCoAmlcurranSocialTime>)plusDaysWithInt:(jint)days
{
    return [[ObjCTime alloc] init];
}

- (jint)daysSinceEpoch
{
    return 1;
}

- (jlong)getMillis
{
    return 0;
}

@end
