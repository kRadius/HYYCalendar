//
//  HYYCalendarDayCell.h
//  CalendarDemo
//
//  Created by kRadius on 16/5/12.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYYCalendarStatus) {
    HYYCalendarStatusEmpty,
    HYYCalendarStatusPast,
    HYYCalendarStatusToday,
    HYYCalendarStatusFuture,//指这个月之后
};

@interface HYYCalendarDayCell : UICollectionViewCell

@property (assign, nonatomic) HYYCalendarStatus status;
//选中
@property (assign, nonatomic,getter=isMySelected) BOOL mySelected;
//第一天
@property (assign, nonatomic,getter=isFirstDayInCurMonth) BOOL firstDayInCurMonth;
//间隔的背景颜色
@property (assign, nonatomic,getter=isSameColorInCurMon) BOOL sameColorWithCurMonth;

- (void)updateContentWithDate:(NSDate *)cellDate;

@end
