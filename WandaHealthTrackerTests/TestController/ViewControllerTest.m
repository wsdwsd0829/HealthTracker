//
//  ViewControllerTest.m
//  WandaHealthTracker
//
//  Created by sidawang on 5/1/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController+Test.h"
@interface ViewControllerTest : XCTestCase
@property ViewController* vc;
@end

@implementation ViewControllerTest

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    //inject service so do not call async methods; solution:preprocessor macro + change configuration for test sechema
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginFieldSet {
    self.vc.usernameField.text = @"username";
    self.vc.passwordField.text = @"password";
    XCTAssertNotNil(self.vc.usernameField);
    XCTAssertNotNil(self.vc.passwordField);
}



@end
