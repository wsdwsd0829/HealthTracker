//
//  WDHistoryDisplayer.m
//  WandaHealthTracker
//
//  Created by sidawang on 4/27/16.
//  Copyright © 2016 sidex. All rights reserved.
//

#import "WDHistoryDisplayer.h"
#import "PatientMeasurementService.h"
#import "WDConstants.h"
#import "SVProgressHUD.h"
#import "WDMeasurementGeneral.h"
#import "WSDUtils.h"

@interface WDHistoryDisplayer()
@property (weak, nonatomic) IBOutlet UISegmentedControl *daySegmentControl;
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet BarChartView *barChartView;

@property NSInteger displayDayCount;
@property (nonatomic, copy) NSArray* measurementsHeart;
@property (nonatomic, copy) NSArray* measurementsWeight;
@property (nonatomic, copy) NSArray* measurementsHeartForDisplay;
@property (nonatomic, copy) NSArray* measurementsWeightForDisplay;

@property WDMeasurementBuilder *heartBuilder;
@property WDMeasurementBuilder *weightBuilder;

@end

@implementation WDHistoryDisplayer
-(void) initForDisplay{
    self.displayDayCount = 7;
    self.daySegmentControl.selectedSegmentIndex = 0;
   
}

-(void)changeDays:(UISegmentedControl*)sender{
    if(sender == self.daySegmentControl){
        //TODO: replace number with constants
        if(self.daySegmentControl.selectedSegmentIndex == 0){
            self.displayDayCount = 30;
        }else{
            
            self.displayDayCount = 7;
        }
        [self showBarChartForWeight];
        [self showLineChartForHeartRate];
    }
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.daySegmentControl addTarget:self action:@selector(changeDays:) forControlEvents:UIControlEventValueChanged];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [SVProgressHUD show];
    self.displayDayCount = 30;
    
    

    //set up builder and service for HEART RATE
    self.heartBuilder = [[WDMeasurementBuilder alloc] initWithDelegate:self];
    self.heartBuilder.earliestDate = [WSDUtils dateBeforeDate:[NSDate date] withNumberOfDays:self.displayDayCount];
    PatientMeasurementService *heartPms = [[PatientMeasurementService alloc] initWithBuilder:self.heartBuilder];
    [heartPms fetchMeasurementOfType:vMeasurementParamTypeHeartRate ordering:vMeasurementParamOrderingTimeDesc withHandler:nil];
    
    //set up builder and service for WEIGHT
    self.weightBuilder = [[WDMeasurementBuilder alloc] initWithDelegate:self];
    self.weightBuilder.earliestDate = [WSDUtils dateBeforeDate:[NSDate date] withNumberOfDays:self.displayDayCount];
    PatientMeasurementService *weightPms = [[PatientMeasurementService alloc] initWithBuilder:self.weightBuilder];
    [weightPms fetchMeasurementOfType:vMeasurementParamTypeWeight ordering:vMeasurementParamOrderingTimeDesc withHandler: nil];
}
#pragma mark WDMeasurementDelegate
-(void)builder:(WDMeasurementBuilder *)builder didBuildResults:(NSArray *)measurements{
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO: handler error
            [SVProgressHUD dismiss];
            
            if(builder == self.heartBuilder){
                self.measurementsHeart = measurements;
                [self showLineChartForHeartRate];
            }else if(builder == self.weightBuilder){
                self.measurementsWeight = measurements;
                [self showBarChartForWeight];
            }
        });
}
-(void)builder:(WDMeasurementBuilder *)builder failedBuildResultsWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [WSDUtils generalAlertWithTitle:@"Failed" withMessage:[error localizedDescription] withDelegate:self withDefaultBtnMsg:@"OK"];
    });
}
                   
#pragma mark Drawing charts
-(void) showBarChartForWeight{
    
    self.barChartView.delegate = self;
    self.barChartView.descriptionText = @"";
    self.barChartView.drawBarShadowEnabled = NO;
    self.barChartView.drawValueAboveBarEnabled = YES;
    self.barChartView.maxVisibleValueCount = 40;
    
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.spaceBetweenLabels = 5.0;
    
    ChartYAxis *leftAxis = self.barChartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 10;
    
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 1;
    /*
    leftAxis.valueFormatter.negativeSuffix = @" $";
    leftAxis.valueFormatter.positiveSuffix = @" $";
     */
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
   

    
    ChartYAxis *rightAxis = self.barChartView.rightAxis;
    rightAxis.enabled = NO;

    self.barChartView.legend.position = ChartLegendPositionAboveChartCenter;
    self.barChartView.legend.form = ChartLegendFormSquare;
    self.barChartView.legend.formSize = 7.0;
    self.barChartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    self.barChartView.legend.xEntrySpace = 5.0;

    
    NSDate* startDate = [WSDUtils dateBeforeDate:[NSDate date] withNumberOfDays:self.displayDayCount];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"date >= %@", startDate];
    self.measurementsWeightForDisplay = [self.measurementsWeight filteredArrayUsingPredicate:pred];
    
    [self setDataCountBarForWeight:(int)MIN(self.displayDayCount, self.measurementsWeightForDisplay.count) range: [self rangeInMeasurements:self.measurementsWeightForDisplay]];
    
}
-(void) showLineChartForHeartRate{
    self.lineChartView.delegate = self;
    self.lineChartView.descriptionText = @"";
    self.lineChartView.noDataTextDescription = @"You need to provide data for the chart.";
    ChartYAxis *rightAxis = self.lineChartView.rightAxis;
    rightAxis.enabled = NO;

    ChartYAxis *leftAxis = self.lineChartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 0;
    
    ChartXAxis *xAxis = self.lineChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.spaceBetweenLabels = 5.0;
    
    self.lineChartView.dragEnabled = YES;
    [self.lineChartView setScaleEnabled:YES];
    self.lineChartView.pinchZoomEnabled = YES;
    self.lineChartView.drawGridBackgroundEnabled = NO;
    
    self.lineChartView.legend.position = ChartLegendPositionAboveChartCenter;
    self.lineChartView.legend.form = ChartLegendFormCircle;
    self.lineChartView.legend.formSize = 7.0;
    self.lineChartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    self.lineChartView.legend.xEntrySpace = 5.0;
    
    NSDate* startDate = [WSDUtils dateBeforeDate:[NSDate date] withNumberOfDays:self.displayDayCount];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"date >= %@", startDate];
    self.measurementsHeartForDisplay = [self.measurementsHeart filteredArrayUsingPredicate:pred];
    [self setDataCountLineForHeartRate: (int)self.measurementsHeartForDisplay.count range:[self rangeInMeasurements:self.measurementsHeartForDisplay]];
}

- (void)setDataCountLineForHeartRate:(int)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < count; i++)
    {
        
        NSInteger heartRate = [((WDMeasurementGeneral*)self.measurementsHeartForDisplay[i]).value integerValue];
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:(double)heartRate xIndex:i]];
    }
    
    LineChartDataSet *set1 = nil;
    if (self.lineChartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)self.lineChartView.data.dataSets[0];
        set1.yVals = yVals;
        self.lineChartView.data.xValsObjc = xVals;
        [self.lineChartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"Heart Rate Data"];//@"DataSet 1"
        
        set1.lineDashLengths = @[@5.f, @2.5f];
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
        [set1 setColor:UIColor.blackColor];
        [set1 setCircleColor:UIColor.blackColor];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:7.f];
        //set1.fillAlpha = 65/255.0;
        //set1.fillColor = UIColor.blackColor;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:1];
        [formatter setMinimumFractionDigits:1];
        set1.valueFormatter = formatter;

        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
        
        self.lineChartView.data = data;
    }
}
- (void)setDataCountBarForWeight:(int)count range:(double)range
{
    ChartYAxis *leftAxis = self.barChartView.leftAxis;
    leftAxis.axisMinValue = [self getBarMinForMeasurements:self.measurementsWeightForDisplay]; // this replaces startAtZero = YES

    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        float weight = [((WDMeasurementGeneral*)self.measurementsWeightForDisplay[i]).value floatValue];
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:weight xIndex:i]];
    }
    
    BarChartDataSet *set1 = nil;
    if (self.barChartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)self.barChartView.data.dataSets[0];
        set1.yVals = yVals;
      //  [set1 setColors:ChartColorTemplates.material];
        
        [set1 setColors: @[[UIColor greenColor],[UIColor greenColor],[UIColor greenColor],[UIColor greenColor]]];

        set1.valueColors = @[[UIColor greenColor]];
        set1.barShadowColor = [UIColor greenColor];
        self.barChartView.data.xValsObjc = xVals;
        [self.barChartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"Weight Data"];
        set1.barSpace = 0.35;
        [set1 setColors:ChartColorTemplates.material];
         [set1 setColors: @[[UIColor greenColor]]];//,[UIColor greenColor],[UIColor greenColor],[UIColor greenColor]
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:1];
        [formatter setMinimumFractionDigits:1];
        set1.valueFormatter = formatter;
        BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
        self.barChartView.data = data;
    }
}

#pragma mark - helpers

-(NSInteger)getBarMinForMeasurements:(NSArray*)measurements{
    float min = CGFLOAT_MAX;
    for(int i = 0;i < measurements.count; i++){
        WDMeasurementGeneral* measurement = measurements[i];
        min = MIN([measurement.value floatValue], min);
       
    }
    NSInteger guess = (int)min/10 * 10;
    return (NSInteger)guess;
}
-(NSInteger) rangeInMeasurements:(NSArray*)measurements{
    NSInteger min = CGFLOAT_MAX;
    NSInteger max = 0;
    for(int i = 0;i< measurements.count; i++){
        WDMeasurementGeneral* measurement = measurements[i];
        min = MIN([measurement.value floatValue], min);
        max = MAX([measurement.value floatValue], max);
    }
    return (NSInteger)(max - min + 1);
}

@end
