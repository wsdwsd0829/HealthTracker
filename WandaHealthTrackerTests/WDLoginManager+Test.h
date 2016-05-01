//
//  PatientMeasurementService+Test.h
//  WandaHealthTracker
//
//  Created by sidawang on 4/30/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDLoginManager.h"

@interface WDLoginManager (Test)

-(NSURLRequest*)getTokenURLRequestForUser:(NSString *)username withPassword:(NSString *)password;

@end
