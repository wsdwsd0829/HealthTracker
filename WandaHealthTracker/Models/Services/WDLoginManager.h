//
//  WDTokenManager.h
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^tokenHandler)(NSString* token);

@interface WDLoginManager : NSObject

+(instancetype) defaultManager;
@property (nonatomic, copy) NSString* token;

-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(tokenHandler)loginHandler;
@end
