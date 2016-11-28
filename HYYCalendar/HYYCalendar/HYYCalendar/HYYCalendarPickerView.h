//
//  HYYCalendarPickerView.h
//  CalendarDemo
//
//  Created by kRadius on 16/5/13.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSUInteger kTimeIntervalDay;
extern const NSUInteger kTimeIntervalWeek;
extern const NSUInteger kTimeIntervalMonth;

typedef void (^PickerConfirmCallBack)(NSDate *date, NSUInteger days, NSUInteger unit);

@interface HYYCalendarPickerView : UIView

@property (strong, nonatomic) NSDate *selectedDate;


@property (copy, nonatomic) PickerConfirmCallBack pickerCallback;

- (instancetype)initWithFrame:(CGRect)frame number:(NSUInteger)number unit:(NSUInteger)unit;

@end
