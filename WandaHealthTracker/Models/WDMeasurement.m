//
//  WDMeasurement.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/30/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDMeasurement.h"

@implementation WDMeasurement

- (instancetype)initWithHeartRate:(NSInteger)rate withDate:(NSDate*) date
{
   self = [self initWithWeight:0.0 withHeartRate:rate withDate:date];
    return self;
}
- (instancetype)initWithWeight:(float)weight withDate:(NSDate*) date
{
    self = [self initWithWeight:weight withHeartRate:0 withDate:date];
    return self;
}
//designated initializer
- (instancetype)initWithWeight:(float)weight withHeartRate:(NSInteger)rate withDate:(NSDate*) date
{
    self = [super init];
    if (self) {
        self.heartRate = rate;
        self.weight = weight;
        self.date = date;
    }
    return self;
}
@end
