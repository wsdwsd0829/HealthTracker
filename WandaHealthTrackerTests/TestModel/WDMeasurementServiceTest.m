//
//  WDMeasurementServiceTest.m
//  WandaHealthTracker
//
//  Created by sidawang on 5/1/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PatientMeasurementServiceSubTest.h"
#import "WDMeasurementBuilderSubTest.h"
#import "WDMeasurementBuilder.h"

@interface WDMeasurementServiceTest : XCTestCase
@property PatientMeasurementServiceSubTest* pms;
@property WDMeasurementBuilderSubTest* builder;
@end

@implementation WDMeasurementServiceTest

- (void)setUp {
    [super setUp];
    self.builder = [[WDMeasurementBuilderSubTest alloc] initWithDelegate:nil];
    self.pms = [[PatientMeasurementServiceSubTest alloc] initWithBuilder:(WDMeasurementBuilder*)self.builder];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUrlCreation {
    NSDictionary* params = @{@"key1": @"value1",
                             @"key2": @"value2"};
    NSString* requestUrlString = [self.pms getRequestStringWithParams:params];
    NSString* shouldBe = [NSString stringWithFormat:@"%@?%@",kMeasurementApi, @"key1=value1&key2=value2"];
    XCTAssertEqualObjects(requestUrlString, shouldBe);
}

-(void)testTypeOfMeasurementFromUrlString{
    NSString* url = @"https://interview.wandalive.com/api/patient_app/measurement/?key1=value1&type=atype";
   NSString *type =  [self.pms typeOfMeasurementFromUrlString:url forTypeKey:@"type"];
    XCTAssertEqualObjects(type, @"atype");
}
-(void)testGetAuthStringWithToken{
    NSString* res = [self.pms getAuthStringWithToken:@"atoken"];
    XCTAssertEqualObjects(res, @"Token atoken");
}
-(void) testFetchRequestWithFalseUrlFailed{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
   [self.pms fetchMeasurementUrl:@"not a url" withHandler:^(NSData *data, NSURLResponse *response, NSError *error, NSString *type) {
       XCTAssertNotNil(error);
       NSLog(@"this Handler should call first");

       dispatch_semaphore_signal(semaphore);
   }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    NSLog(@"Wait Handler call first");
}

-(void) testFetchRequestWithEmptyUrlFailed{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.pms fetchMeasurementUrl:nil withHandler:^(NSData *data, NSURLResponse *response, NSError *error, NSString *type) {
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, WDErrorCodeURLInvalid);
        NSLog(@"this Handler should call first");
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"Wait Handler call first");
}

//a success fetch will call delegate's success handler
-(void)testFetchRequestSuccessWillCallDelegate{
    self.pms.shouldSuccess = YES;
    XCTAssertFalse(self.builder.successDelegateCalled);
    [self.pms fetchMeasurementOfType:@"success" ordering:@"" withHandler:^(NSData *data, NSURLResponse *response, NSError *error, NSString *type) {
        
    }];
    XCTAssertTrue(self.builder.successDelegateCalled);
    
}
//a success fetch will call delegate's success handler
-(void)testFetchRequestFailWillCallDelegate{
    self.pms.shouldFail = YES;
    XCTAssertFalse(self.builder.failDelegateCalled);
    [self.pms fetchMeasurementOfType:@"success" ordering:@"" withHandler:^(NSData *data, NSURLResponse *response, NSError *error, NSString *type) {
        
    }];
    XCTAssertTrue(self.builder.failDelegateCalled);
    
}

@end
