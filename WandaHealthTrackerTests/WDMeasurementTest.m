//
//  WDMeasurementTest.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/30/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WDMeasurement.h"
@interface WDMeasurementTest : XCTestCase

@end

@implementation WDMeasurementTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDesignatedInitializer {
    WDMeasurement* measurement = [[WDMeasurement alloc] initWithWeight:90.0 withHeartRate:90 withDate:[NSDate date]];
    XCTAssertEqual(measurement.weight, 90.0);
    XCTAssertEqual(measurement.heartRate, 90);
    XCTAssertNotNil(measurement.date);
}
- (void)testInitializerWeight {
    WDMeasurement* measurement = [[WDMeasurement alloc] initWithWeight:90.0 withDate:[NSDate date]];
    XCTAssertEqual(measurement.weight, 90.0);
    XCTAssertEqual(measurement.heartRate, 0);
    XCTAssertNotNil(measurement.date);
}
- (void)testInitializerHeart {
    WDMeasurement* measurement = [[WDMeasurement alloc] initWithHeartRate:90.0 withDate:[NSDate date]];
    XCTAssertEqual(measurement.weight, 0);
    XCTAssertEqual(measurement.heartRate, 90.0);
    XCTAssertNotNil(measurement.date);
}

@end
