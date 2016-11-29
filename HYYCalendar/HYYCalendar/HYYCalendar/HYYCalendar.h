//
//  HYYCalendar.h
//  CalendarDemo
//
//  Created by kRadius on 16/5/12.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYYCalendarType){
    HYYCalendarTypeCollection,
    HYYCalendarTypePicker
};

typedef NS_ENUM(NSUInteger, HYYCalendarUnit){
    HYYCalendarUnitDay = 1,
    HYYCalendarUnitWeek,
    HYYCalendarUnitMonth
};


@class HYYCalendar;

@protocol HYYCalendarDelegate <NSObject>

/**
 *  选中日期
 *
 *  @param calendar self
 *  @param date     选中的date对象
 *  @param number   距离多少 时间单位（unit）
 *  @param unit     1:天 2:周 3:月
 */
- (void)calendar:(HYYCalendar *)calendar didSelectDate:(NSDate *)date number:(NSUInteger)number unit:(HYYCalendarUnit)unit;

@end

@interface HYYCalendar : UIView

@property (assign, nonatomic, readonly) HYYCalendarType calendarType;

@property (weak, nonatomic) id<HYYCalendarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame number:(NSUInteger)number unit:(HYYCalendarUnit)unit type:(HYYCalendarType)type;

- (void)show;
- (void)hide;

@end
