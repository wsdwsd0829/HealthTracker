//
//  WDMeasurementBuilderSubTest.m
//  WandaHealthTracker
//
//  Created by sidawang on 5/1/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDMeasurementBuilderSubTest.h"

@implementation WDMeasurementBuilderSubTest

-(void)measurementService:(PatientMeasurementService *)pms successWithData:(NSData *)data{
    self.successDelegateCalled = YES;
    //[super measurementService:pms successWithData:data];
}
-(void)measurementService:(PatientMeasurementService *)pms failedWithError:(NSError *)error{
    self.failDelegateCalled = YES;
    //[super measurementService:pms failedWithError:error];
}
@end
