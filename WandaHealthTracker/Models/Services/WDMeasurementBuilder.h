//
//  WDMeasurementBuilder.h
//  WandaHealthTracker
//
//  Created by sidawang on 4/30/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientMeasurementService.h"
@class WDMeasurementBuilder;
@protocol WDMeasurementDelegate <NSObject>
-(void)builder:(WDMeasurementBuilder*)builder didBuildResults:(NSArray*) measurements;
-(void)builder:(WDMeasurementBuilder*)builder failedBuildResultsWithError:(NSError*) error;
@end


@interface WDMeasurementBuilder : NSObject <WDMeasurementServiceDelegate>

@property id<WDMeasurementDelegate> delegate;
@property NSDate* earliestDate;

-(instancetype)initWithDelegate:(id<WDMeasurementDelegate>) delegate;

@end
