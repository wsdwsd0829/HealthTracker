//
//  WDMeasurementBuilderTest.m
//  WandaHealthTracker
//
//  Created by sidawang on 5/1/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WDMeasurementBuilderSubTest.h"
#import "WDMeasurementGeneral.h"
@interface WDMeasurementBuilderTest : XCTestCase
@property WDMeasurementBuilderSubTest* builder;
@end

@implementation WDMeasurementBuilderTest

- (void)setUp {
    [super setUp];
    self.builder = [[WDMeasurementBuilderSubTest alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBuilderParse {
    NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"sample" ofType:@"bin"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSArray* parseResults = [self.builder parseResults:data];
    XCTAssertTrue(parseResults.count > 0);
    XCTAssertTrue([parseResults[0] isKindOfClass:[WDMeasurementGeneral class]]);
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}



@end
