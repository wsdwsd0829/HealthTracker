//
//  PatientMeasurementServiceSubTest.m
//  WandaHealthTracker
//
//  Created by sidawang on 5/1/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "PatientMeasurementServiceSubTest.h"

@implementation PatientMeasurementServiceSubTest

-(void)fetchMeasurementOfType:(NSString *)type ordering:(NSString *)ordering withHandler:(sessionTaskHandler)sessionHander{
    if(self.shouldSuccess == YES){
        [self.delegate measurementService:self successWithData:[[NSData alloc] init]];
    }else if(self.shouldFail == YES){
        [self.delegate measurementService:self failedWithError:[[NSError alloc] init]];
    }else{
        [super fetchMeasurementOfType:type ordering:ordering withHandler: sessionHander];
    }
}

@end
