//
//  ViewController.m
//  HYYCalendar
//
//  Created by kRadius on 2016/11/28.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "ViewController.h"
#import "HYYCalendar.h"
#import "HYYCalendar+Helper.h"
#import "NSDate+Agenda.h"

@interface ViewController () <HYYCalendarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectedDateLabel;

@property (assign, nonatomic) HYYCalendarUnit unit;
@property (assign, nonatomic) NSUInteger number;
//@property (assign, nonatomic) HYYCalendarType calendarType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unit = HYYCalendarUnitDay;
    self.number = 12;
}

#pragma mark - Action
- (IBAction)selectBtnClicked:(id)sender {
    
    HYYCalendar *calendar = [[HYYCalendar alloc] initWithFrame:self.navigationController.view.bounds number:self.number unit:self.unit type:HYYCalendarTypeCollection];
    calendar.delegate = self;
    [self.navigationController.view addSubview:calendar];
    [calendar show];
}

#pragma mark - HYYCalendarDelegate
- (void)calendar:(HYYCalendar *)calendar didSelectDate:(NSDate *)date number:(NSUInteger)number unit:(HYYCalendarUnit)unit {
    self.number = number;
    self.unit = unit;
    NSString *dateString = [[NSString stringWithFormat:@"%ld%@后", number, [calendar unitString]] stringByAppendingFormat:@"（%@）", [date dateStringWithFormat:@"yyyy-MM-dd"]];
    
    self.selectedDateLabel.text = dateString;
}

@end
