//
//  PatientMeasurementService.h
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDConstants.h"

@class PatientMeasurementService;
@class WDMeasurementBuilder;
@protocol WDMeasurementServiceDelegate
-(void) measurementService:(PatientMeasurementService*)pms successWithData:(NSData*)data;
-(void) measurementService:(PatientMeasurementService*)pms failedWithError:(NSError*)error;
@end

@interface PatientMeasurementService : NSObject

- (instancetype)initWithBuilder:(WDMeasurementBuilder*)builder;

@property (weak) id<WDMeasurementServiceDelegate> delegate;

-(void)fetchMeasurementUrl:(NSString*)urlStr withHandler:(sessionTaskHandler) sessionHander;

-(void)fetchMeasurementOfType:(NSString*)type ordering:(NSString*)ordering  withHandler:(sessionTaskHandler) sessionHander;

@end
