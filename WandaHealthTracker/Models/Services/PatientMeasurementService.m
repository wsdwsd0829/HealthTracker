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
@property (copy) sessionTaskHandler sessHandler;
@end

@implementation PatientMeasurementService
- (instancetype)initWithBuilder:(WDMeasurementBuilder*)builder
{
    self = [super init];
    if (self) {
        self.delegate = builder;
        //self.sessHandler = ^(NSData *  data, NSURLResponse *  response, NSError *  error, NSString* type){}
           }
    return self;
}
-(void)fetchMeasurementUrl:(NSString*)urlStr withHandler:(sessionTaskHandler) sessionHander{
    if(!urlStr || urlStr.length == 0){
        NSError* error = [NSError errorWithDomain:WDErrorDomainURLInvalid code:WDErrorCodeURLInvalid userInfo:@{@"description":@"url cannot be nil or empty"}];
        if(sessionHander){
            ((sessionTaskHandler)[sessionHander copy])(nil,nil, error, nil);
        }
        return;
    }
    
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
    NSString* type = [self typeOfMeasurementFromUrlString:urlStr forTypeKey:kMeasurementParamType];
    
    //__weak PatientMeasurementService* weakself = self; //no need here
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        PatientMeasurementService * strongSelf = self;
        if(error == nil && ((NSHTTPURLResponse*)response).statusCode == 200){
            [strongSelf.delegate measurementService:strongSelf successWithData:data];
        }else{
            //system error
            if(error != nil){
                [strongSelf.delegate measurementService:strongSelf failedWithError:error];
                return;
            }else{
                //application error;
                if(((NSHTTPURLResponse*)response).statusCode == 401){
                    
                    NSError * parseError = nil;
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
                    if(parseError){
                        [strongSelf.delegate measurementService:strongSelf failedWithError:parseError];
                    }else{
                        if([dict objectForKey:@"detail"]){
                            NSError* serverReturnError = [NSError errorWithDomain:WDErrorDomainTokenInvalid code:WDErrorCodeTokenInvalid userInfo:@{@"description":dict[@"detail"]}];
                            [strongSelf.delegate measurementService:strongSelf failedWithError:serverReturnError];
                        }else{
                             NSError* serverReturnError = [NSError errorWithDomain:WDErrorDomainTokenInvalid code:WDErrorCodeTokenInvalid userInfo:@{@"description":dict}];
                            [strongSelf.delegate measurementService:strongSelf failedWithError:serverReturnError];
                        }
                    }
                }else{
                    NSString* errorInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSError* serverReturnError = [NSError errorWithDomain:WDErrorDomainServerGeneralInvalid code:WDErrorCodeServerGeneralInvalid userInfo:@{@"description":errorInfo}];
                    [strongSelf.delegate measurementService:strongSelf failedWithError:serverReturnError];
                }
            }
            
        }
        NSLog(@"data string %@, response %@, error %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], response, error);
        
        //((sessionTaskHandler)[strongSelf.sessHandler copy])(data, response, error, type);
        if(sessionHander){
            ((sessionTaskHandler)[sessionHander copy])(data, response, error, type);

        }
    }];
    [dataTask resume];
    [session finishTasksAndInvalidate];
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
//-(NSString*) typeOfMeasurementFromUrlString:(NSString*)urlStr{
-(NSString*) typeOfMeasurementFromUrlString:(NSString*)urlStr forTypeKey:(NSString*)typeKey{
    NSURLComponents *components = [NSURLComponents componentsWithString:urlStr];
    for(NSURLQueryItem* item in components.queryItems){
        if([item.name isEqualToString:typeKey]){
            return item.value;
        }
    }
    return nil;
}
-(NSString*)getAuthStringWithToken:(NSString*)token{
    return [NSString stringWithFormat:@"Token %@", token];
}

@end
