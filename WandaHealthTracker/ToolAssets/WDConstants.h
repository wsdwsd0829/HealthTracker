//
//  WDConstants.h
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^sessionTaskHandler)(NSData *  data, NSURLResponse *  response, NSError *  error, NSString* type);

@interface WDConstants : NSObject

#pragma mark - Query Apis
extern NSString* const kTokenApi;
extern NSString* const kMeasurementApi;

#pragma mark - Query parameters

//token api post params:
extern NSString* const kTokenUsername;
extern NSString* const kTokenPassword;

//Measurement type api params
extern NSString* const kMeasurementParamType;
extern NSString* const vMeasurementParamTypeWeight;
extern NSString* const vMeasurementParamTypeHeartRate;
extern NSString* const kMeasurementParamPage;

//Measurement order api params
extern NSString* const kMeasurementParamOrdering;
extern NSString* const vMeasurementParamOrderingTimeDesc;
extern NSString* const vMeasurementParamOrderingTimeAsc;

#pragma mark - Test data
//TODO: to remove before launch
extern NSString* const kTestPatientUsername;
extern NSString* const kTestPatientPassword;

#pragma mark - Error Domains
extern NSString* const WDFetchResultsInvalid;
@end
