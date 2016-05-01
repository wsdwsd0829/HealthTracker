//
//  PatientMeasurementServiceSubTest.h
//  WandaHealthTracker
//
//  Created by sidawang on 5/1/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "PatientMeasurementService.h"
#import "WDMeasurementBuilderSubTest.h"

@interface PatientMeasurementServiceSubTest : PatientMeasurementService

@property WDMeasurementBuilderSubTest* builder;
@property BOOL shouldSuccess ;
@property BOOL shouldFail;
-(NSString*)getRequestStringWithParams:(NSDictionary*)params;
-(NSString*) typeOfMeasurementFromUrlString:(NSString*)urlStr forTypeKey:(NSString*)typeKey;
-(NSString*)getAuthStringWithToken:(NSString*)token;

@end
