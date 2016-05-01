//
//  WDConstants.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDConstants.h"


@implementation WDConstants

#pragma mark - Query Apis
//!!!better use facade pattern to provide url & api end point from webservice in case URI changes
NSString* const kTokenApi = @"https://interview.wandalive.com/api/patient_app/token/";
NSString* const kMeasurementApi = @"https://interview.wandalive.com/api/patient_app/measurement/";

#pragma mark - Query parameters
NSString* const kTokenUsername = @"username";
NSString* const kTokenPassword = @"password";

NSString* const kMeasurementParamType = @"measurement_type";
NSString* const kMeasurementParamOrdering = @"ordering";
NSString* const kMeasurementParamPage = @"page";

NSString* const vMeasurementParamTypeWeight = @"weight";
NSString* const vMeasurementParamTypeHeartRate = @"heart_rate";
NSString* const vMeasurementParamOrderingTimeDesc = @"-measurement_time";
NSString* const vMeasurementParamOrderingTimeAsc = @"measurement_time";

#pragma mark - Test data
//TODO: to remove before launch
NSString* const kTestPatientUsername = @"c2pval";
NSString* const kTestPatientPassword = @"BHx5YSz5Xu";

#pragma mark - Error Domains
NSString* const WDErrorDomainFetchResultsInvalid = @"WDFetchResultsInvalid";
NSString* const WDErrorDomainURLInvalid = @"WDErrorDomainURLInvalid";
NSString* const WDErrorDomainTokenInvalid = @"WDErrorDomainTokenInvalid";
NSString* const WDErrorDomainServerGeneralInvalid = @"WDErrorDomainServerGeneralInvalid";
NSString* const WDErrorDomainGetTokenFail = @"WDErrorDomainGetTokenFail";

@end
