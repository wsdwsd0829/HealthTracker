//
//  WDMeasurementBuilderSubTest.h
//  WandaHealthTracker
//
//  Created by sidawang on 5/1/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDMeasurementBuilder.h"

@interface WDMeasurementBuilderSubTest : WDMeasurementBuilder
-(NSArray*)parseResults:(NSData*)data;
@property BOOL successDelegateCalled;
@property BOOL failDelegateCalled;
@end
