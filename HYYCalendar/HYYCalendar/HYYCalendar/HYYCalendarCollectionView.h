//
//  HYYCalendarCollectionView.h
//  CalendarDemo
//
//  Created by kRadius on 16/5/12.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CalendarConfirmCallBack)(NSDate *date, NSUInteger days);

@interface HYYCalendarCollectionView : UIView

@property (strong, nonatomic) NSDate *selectedDate;
@property (assign, nonatomic) NSInteger defaultSelectedIndex;

@property (copy, nonatomic) CalendarConfirmCallBack calendarCallback;

- (instancetype)initWithFrame:(CGRect)frame fromDate:(NSDate *)fromeDate toDate:(NSDate *)toDate;

@end
