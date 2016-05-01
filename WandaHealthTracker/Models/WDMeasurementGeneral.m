//
//  WDMeasurementReal.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/30/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDMeasurementGeneral.h"

@implementation WDMeasurementGeneral

- (instancetype)initWithType:(NSString*)type withValue:(id)value withDate:(NSDate*)date
{
    self = [super init];
    if (self) {
        _type = type;
        _value = value;
        _date = date;
    }
    return self;
}
-(NSString*)description{
    return [NSString stringWithFormat:@"mg: %@, %@, %@", self.type, self.date, self.value];
}
@end

