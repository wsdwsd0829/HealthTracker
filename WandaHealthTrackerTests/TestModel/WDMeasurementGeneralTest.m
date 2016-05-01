//
//  WDMeasurementGeneralTest.m
//  WandaHealthTracker
//
//  Created by sidawang on 5/1/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WDMeasurementGeneral.h"
@interface WDMeasurementGeneralTest : XCTestCase

@end

@implementation WDMeasurementGeneralTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDesignatedInitializer {
    WDMeasurementGeneral* measurement = [[WDMeasurementGeneral alloc] initWithType:@"type" withValue:@90 withDate:[NSDate date]];
    XCTAssertEqual(measurement.type, @"type");
    XCTAssertEqual(measurement.value, @90);
    XCTAssertNotNil(measurement.date);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
