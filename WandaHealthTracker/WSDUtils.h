//
//  WSDUtils.h
//  icloudtest
//
//  Created by sidawang on 4/12/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface WSDUtils : NSObject
#pragma mark - date related
+(NSDate *)endOfDay:(NSDate *)date;
+(NSDate *)beginningOfDay:(NSDate *)date;
+(void)checkICloudCredentialsSuccess:(void(^)(CKAccountStatus accountStatus))successHandler
                              failed:(void(^)(NSError*  error))failHandelr;
+(NSString*) formatDateToKey:(NSDate*)date;
+(NSDate*)dateWithoutTime:(NSDate*)date;
+(NSDateComponents*) dateComponetsFromDate:(NSDate*)date;
+(NSString*) formatDateToFullString:(NSDate*)date withFormatString:(NSString*)formatString;
+(NSDate*)formatFullDateStringToDate:(NSString*)dateStr withFormatString:(NSString*)formatString;
+(NSDate*)dateBeforeDate:(NSDate*)date withNumberOfDays:(NSInteger)num;
+ (NSDateFormatter *)networkDateFormatter;

+(void)generalAlertWithTitle:(NSString*) title withMessage:(NSString*)msg withDelegate:(id)delegate withDefaultBtnMsg:(NSString*)btnMsg;
+(void)simpleAlertForController:(UIViewController*)viewController;

+(float)randomFloatBetween:(float)smallNumber and:(float)bigNumber;
@end
