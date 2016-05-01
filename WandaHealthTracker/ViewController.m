//
//  ViewController.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "ViewController.h"
#import "PatientMeasurementService.h"
#import "WDConstants.h"
#import "WDLoginManager.h"
#import "WDHistoryDisplayer.h"
#import "WSDUtils.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
-(IBAction)login:(id)sender;
- (IBAction)tryDisplayChart:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameField.text = kTestPatientUsername;
    self.passwordField.text = kTestPatientPassword;
   // PatientMeasurementService* pms = [[PatientMeasurementService alloc] init];
    
    //[pms fetchMeasurementOfType:@"weight" ordering:vMeasurementParamOrderingTimeDesc];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)login:(id)sender{
    __weak ViewController* weakself = self;
    
    [[WDLoginManager defaultManager] loginWithUsername:self.usernameField.text withPassword:self.passwordField.text withHandler:^(NSString *token, NSError* error) {
        ViewController * strongSelf = weakself;
        //perform segue
        if(token && token.length>0){
            // [[NSOperationQueue mainQueue] addOperationWithBlock:^{           // }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf displayChart];
            });
        }else{
            //TODO: alert error
            [WSDUtils generalAlertWithTitle:@"Login Failed" withMessage:@"Faild to login" withDelegate:strongSelf withDefaultBtnMsg:@"OK"];
        }
    }];
}

//this is trying to use cashed token instead of querying every time;
- (IBAction)tryDisplayChart:(id)sender {
    /*
    if([[WDLoginManager defaultManager] token].length > 0){
        [self displayChart];
    }else{
        //TODO: alert login
    }*/
    [self displayChart];
}

-(void)displayChart{
    WDHistoryDisplayer* displayer = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WDHistoryDisplayer"];
    [self.navigationController pushViewController:displayer animated:YES];
}

@end
