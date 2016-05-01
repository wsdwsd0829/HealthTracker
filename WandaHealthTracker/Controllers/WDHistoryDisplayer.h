//
//  WDHistoryDisplayer.h
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;
#import "WDMeasurementBuilder.h"

@interface WDHistoryDisplayer : UIViewController<ChartViewDelegate, WDMeasurementDelegate>
@end
