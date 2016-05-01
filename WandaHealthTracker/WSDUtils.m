//
//  WSDUtils.m
//  icloudtest
//
//  Created by sidawang on 4/12/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WSDUtils.h"

@implementation WSDUtils
+(NSDate*)dateWithoutTime:(NSDate*)date{
    if(date == nil){
        date = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}
+(NSDateComponents*) dateComponetsFromDate:(NSDate*)date{
    if(date == nil){
        date = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    
    return comps;
}
+(NSDate*)currentLocalDate{
    NSDate *now = [NSDate date];
    NSDate *startOfToday = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startOfToday interval:NULL forDate:now];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    return now;
}
+(NSString*) formatDateToKey:(NSDate*)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    return [formatter stringFromDate:date];
}
+(NSString*) formatDateToFullString:(NSDate*)date withFormatString:(NSString*)formatString{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    if(!formatString) formatString = @"MM-dd-yyyy HH:mm:ss";
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}
+(NSDate*)formatFullDateStringToDate:(NSString*)dateStr withFormatString:(NSString*)formatString{
    if(!formatString) formatString = @"MM-dd-yyyy HH:mm:ss";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter dateFromString:dateStr];
}
+(NSDate*)dateBeforeDate:(NSDate*)date withNumberOfDays:(NSInteger)num{
    if(!date) date = [NSDate date];
    return [NSDate dateWithTimeInterval:-num*3600*24 sinceDate:date];
}

+(NSDate *)beginningOfDay:(NSDate *)date
{
    
    //this will return local date, in consistant with UTC date used in other part of app
   /*
    NSCalendar *cal = [NSCalendar currentCalendar];
     NSDateComponents *components = [cal components:(NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
    */
    NSDate *now = [NSDate date];
    NSDate *startOfToday = nil;
     [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startOfToday interval:NULL forDate:now];
    return startOfToday;
}

+(NSDate *)endOfDay:(NSDate *)date
{
    /*
      //this will return local date, in consistant with UTC date used in other part of app
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitDay|NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    return [cal dateFromComponents:components];
     */
    NSDate* enddate = [WSDUtils beginningOfDay:[NSDate date]];
   
    return  [enddate dateByAddingTimeInterval:24*3600];
}
+ (NSDateFormatter *)networkDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    return dateFormatter;
}

+(void)checkICloudCredentialsSuccess:(void(^)(CKAccountStatus accountStatus))successHandler
                              failed:(void(^)(NSError*  error))failHandelr{
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            failHandelr(error);
        }
        else {
            successHandler(accountStatus);
        }
    }];
}
+(void)simpleAlertForController:(UIViewController*)viewController{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                                                   message:@"Sign in to your iCloud account to write abstract. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}
+ (void)showSimpleAlertWithMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"OK", nil];
    [alert show];
}
#pragma mark - UI related
+(void)generalAlertWithTitle:(NSString*) title withMessage:(NSString*)msg withDelegate:(id)delegate withDefaultBtnMsg:(NSString*)btnMsg{
    if ([UIAlertController class]) {
        // use UIAlertController
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:title  message:msg   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:btnMsg style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:defaultAction];
        [delegate presentViewController:alertController animated:YES completion:nil];
        
    } else {
        // use UIAlertView
        UIAlertView * message = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:btnMsg otherButtonTitles:nil, nil];
        [message show];
    }
}
+(float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}
@end
