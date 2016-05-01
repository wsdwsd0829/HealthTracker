//
//  WDTokenManager.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDLoginManager.h"
#import "WDConstants.h"

@implementation WDLoginManager

+(instancetype) defaultManager{
    static WDLoginManager* tokenManager;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        tokenManager = [[WDLoginManager alloc] init];
    });
    return tokenManager;
}

#pragma mark - Public Apis
-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(tokenHandler)loginHandler{
    [self fetchTokenForUser:username withPassword:password withHandler:^(NSString *token) {
        loginHandler(token);
    }];
}
-(void)fetchTokenForUser:(NSString *)username withPassword:(NSString *)password withHandler:(tokenHandler)tokenHandler{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLRequest* request = [self getTokenURLRequestForUser:username withPassword:password];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //TODO: error handling
        if(!error && [(NSHTTPURLResponse*)response statusCode] == 200){
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]; //[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.token = result[@"token"];
            tokenHandler(self.token);
        }
    }];
    [dataTask resume];
}
-(NSURLRequest*)getTokenURLRequestForUser:(NSString *)username withPassword:(NSString *)password{
    NSURL *tokenUrl = [NSURL URLWithString:kTokenApi];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:tokenUrl];
    [request setHTTPMethod:@"POST"];
    //set http body
    NSDictionary* queryBodyDict = @{kTokenUsername: username, kTokenPassword:password};
    NSError *error = nil;
    NSData* dataBody = [NSJSONSerialization dataWithJSONObject:queryBodyDict options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:dataBody];
    //set http header
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}


@end
