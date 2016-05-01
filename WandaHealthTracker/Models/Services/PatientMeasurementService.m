//
//  PatientMeasurementService.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PatientMeasurementService.h"
#import "WDLoginManager.h"
#import "WDMeasurementBuilder.h"

@interface PatientMeasurementService()
@end

@implementation PatientMeasurementService
- (instancetype)initWithBuilder:(WDMeasurementBuilder*)builder
{
    self = [super init];
    if (self) {
        self.delegate = builder;
    }
    return self;
}
-(void)fetchMeasurementUrl:(NSString*)urlStr withHandler:(sessionTaskHandler) sessionHander{
    NSURL* measurementUrl = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:measurementUrl];
    NSString *token = [[WDLoginManager defaultManager] token];
    NSLog(@"token used to fetch measurement data: %@", token);
    if(!token){
        //TODO: ask login
    }
    NSString* authHeader = [self getAuthStringWithToken:token];
    // NSString* authHeader = [self getAuthStringWithToken:@"32bbf158962c1279fbd0f3ce1b4b0fab3734a966"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSString* type = [self typeOfMeasurementFromUrlString:urlStr];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        if(error == nil && ((NSHTTPURLResponse*)response).statusCode == 200){
            [self.delegate measurementService:self successWithData:data];
        }else{
            [self.delegate measurementService:self failedWithError:error];
        }
        if(sessionHander){
            sessionHander(data, response, error, type);
        }
        
        NSLog(@"data string %@, response %@, error %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], response, error);
    }];
    [dataTask resume];

    
}
-(void)fetchMeasurementOfType:(NSString*)type ordering:(NSString*)ordering  withHandler:(sessionTaskHandler) sessionHander{
    NSDictionary* params = @{kMeasurementParamType: type,
                             kMeasurementParamOrdering: ordering};
    NSString* requestUrlString = [self getRequestStringWithParams:params];
    [self fetchMeasurementUrl:requestUrlString withHandler:sessionHander];
}

#pragma mark - helper private Methods
-(NSString*)getRequestStringWithParams:(NSDictionary*)params{
    NSURLComponents *components = [NSURLComponents componentsWithString:kMeasurementApi];
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in params) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:params[key]]];
    }
    components.queryItems = queryItems;
   return [components string];
}
-(NSString*) typeOfMeasurementFromUrlString:(NSString*)urlStr{
    NSURLComponents *components = [NSURLComponents componentsWithString:urlStr];
    for(NSURLQueryItem* item in components.queryItems){
        if([item.name isEqualToString:kMeasurementParamType]){
            return item.value;
        }
    }
    return nil;
}
-(NSString*)getAuthStringWithToken:(NSString*)token{
    return [NSString stringWithFormat:@"Token %@", token];
}

@end
