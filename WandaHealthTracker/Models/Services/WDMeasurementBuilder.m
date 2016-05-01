//
//  WDMeasurementBuilder.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/30/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDMeasurementBuilder.h"
#import "WDMeasurementGeneral.h"

@interface WDMeasurementBuilder()
@property (copy, nonatomic) NSString* nextURLString;
@property  NSMutableArray * measurements;
@end

@implementation WDMeasurementBuilder

-(instancetype)initWithDelegate:(id<WDMeasurementDelegate>) delegate{
    self = [super init];
    if(self){
        self.delegate = delegate;
        self.measurements = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)measurementService:(PatientMeasurementService *)pms failedWithError:(NSError *)error{
    [self.delegate builder:self failedBuildResultsWithError:error];
}
-(void)measurementService:(PatientMeasurementService *)pms successWithData:(NSData *)data{
    //[WSDUtils logDataForTesting:data withFileName:@"SampleData.bin"];
    
    [self.measurements addObjectsFromArray: [self parseResults:data]];
    WDMeasurementGeneral* earliestMeasurement = [self.measurements lastObject];
    //have enouth data to earliest date
    //or have fetched all data
    if((earliestMeasurement && [earliestMeasurement.date compare:self.earliestDate] == NSOrderedAscending)
       || self.nextURLString == nil){
        [self.delegate builder:self didBuildResults:self.measurements];
        
    }else{
        //load more data, this will dispatch to another thread and return immediately
        [pms fetchMeasurementUrl:self.nextURLString withHandler:^(NSData *data, NSURLResponse *response, NSError *error, NSString *type) {
        }];
    }
}

-(NSArray*)parseResults:(NSData*)data{
    NSMutableArray* measureResults = [[NSMutableArray alloc] init];
    NSError* error = nil;
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error){
        [self.delegate builder:self failedBuildResultsWithError:error];
    }
    if(![result objectForKey:@"results"]){
        NSError *err = [NSError errorWithDomain:WDErrorDomainFetchResultsInvalid code:WDErrorCodeFetchResultsInvalid userInfo:nil];
        [self.delegate builder:self failedBuildResultsWithError:err];
    }
    
    NSArray* results = result[@"results"];
        
    //TODO check results exsists;
    NSDateFormatter* dateFormatter = [WSDUtils networkDateFormatter];
    for(NSDictionary* dict in results){
        id value = dict[@"measurement_value"];
        NSString* measureType = dict[@"measurement_type"];
        NSDate* date =  [dateFormatter dateFromString:dict[@"measurement_time"]];
        WDMeasurementGeneral* measurement = [[WDMeasurementGeneral alloc] initWithType:measureType withValue:value withDate:date];
        [measureResults addObject:measurement];
    }
   
    //TODO: remote logging, crash report;
    //TODO: parse data to models
    if(error!= nil){
        NSLog(@"Failed to parse measurement data to JSON %@", [error localizedDescription]);
    }
    if(![result[@"next"] isEqual: [NSNull null]]){
        self.nextURLString = result[@"next"];
    }else{
        self.nextURLString = nil;
    }
    return measureResults;
}

@end
