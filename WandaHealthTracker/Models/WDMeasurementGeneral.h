//
//  WDMeasurementReal.h
//  WandaHealthTracker
//
//  Created by sidawang on 4/30/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDMeasurementGeneral : NSObject

@property (copy, nonatomic) NSString* type;
@property (nonatomic) id value;
@property (nonatomic) NSDate* date;

- (instancetype)initWithType:(NSString*)type withValue:(id)value withDate:(NSDate*)date;

@end
