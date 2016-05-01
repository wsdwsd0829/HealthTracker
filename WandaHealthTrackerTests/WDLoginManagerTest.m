//
//  PatientMeasurementServiceTest.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WDLoginManager+Test.h"
#import "WDConstants.h"
@interface WDLoginManagerTest : XCTestCase

@end

@implementation WDLoginManagerTest
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchTokenURLRequest{
    WDLoginManager* lm = [[WDLoginManager alloc] init];
    NSURLRequest* urlRequest = [lm getTokenURLRequestForUser:kTestPatientUsername withPassword:kTestPatientPassword];
    XCTAssertEqualObjects(urlRequest.HTTPMethod, @"POST");
    XCTAssertEqualObjects([urlRequest valueForHTTPHeaderField:@"Content-Type"],@"application/json");
    NSError* error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:urlRequest.HTTPBody options:kNilOptions error:&error];
    XCTAssertTrue( ((NSString*)dict[kTokenUsername]).length > 0);
    XCTAssertTrue( ((NSString*)dict[kTokenPassword]).length > 0);
}

@end
