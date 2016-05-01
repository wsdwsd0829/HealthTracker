//
//  WDMeasurement.h
//  WandaHealthTracker
//
//  Created by sidawang on 4/30/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDMeasurement : NSObject

@property NSInteger heartRate;
@property float weight;
@property NSDate* date;

- (instancetype)initWithHeartRate:(NSInteger)rate withDate:(NSDate*) date;
- (instancetype)initWithWeight:(float)weight withDate:(NSDate*) date;
- (instancetype)initWithWeight:(float)weight withHeartRate:(NSInteger)rate withDate:(NSDate*) date;

@end
