//
//  HYYCalendarDayCell.m
//  CalendarDemo
//
//  Created by kRadius on 16/5/12.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "HYYCalendarDayCell.h"

#import "NSDate+Agenda.h"
#import "UIColor+Utility.h"

#define OnePixel (1.0 / [UIScreen mainScreen].scale)

@interface HYYCalendarDayCell ()

@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *monthLabel;

@end

@implementation HYYCalendarDayCell

#pragma mark - initialize


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self p_initView];
    }
    return self;
}

- (void)p_initView {
    [self addSubview:self.dayLabel];
    [self addSubview:self.monthLabel];
    
    CALayer *verLine = [[CALayer alloc] init];
    verLine.backgroundColor = [UIColor colorWithHex:0xdbdbdb].CGColor;
    verLine.frame = CGRectMake(0, 0, OnePixel,CGRectGetHeight(self.bounds));
    [self.layer addSublayer:verLine];
    
    CALayer *horLine = [[CALayer alloc] init];
    horLine.backgroundColor = [UIColor colorWithHex:0xdbdbdb].CGColor;
    horLine.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - OnePixel, CGRectGetWidth(self.bounds),OnePixel);
    [self.layer addSublayer:horLine];
}

#pragma mark - Public

- (void)updateContentWithDate:(NSDate *)cellDate {
    
    self.userInteractionEnabled = NO;
    
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月",[cellDate monthComponents]];
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",[cellDate dayComponents]];

    self.monthLabel.hidden = YES;
    
    if (self.sameColorWithCurMonth) {
        self.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    } else {
        self.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
    }
    
    if (self.isMySelected) {
        self.monthLabel.hidden = NO;
        self.monthLabel.textColor = [UIColor whiteColor];
        self.dayLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithHex:0x38b8c1];
        
    } else {
        
        if (self.isFirstDayInCurMonth) {
            self.monthLabel.hidden = NO;
            self.monthLabel.textColor = [UIColor colorWithHex:0x888888];
            self.dayLabel.textColor = [UIColor colorWithHex:0x444444];
        }
        
        //cell状态
        if (self.status == HYYCalendarStatusToday) {
            self.monthLabel.hidden = NO;
            self.monthLabel.textColor = [UIColor colorWithHex:0x38b8c1];
            self.dayLabel.textColor = self.monthLabel.textColor;
            
        } else if (self.status == HYYCalendarStatusPast) {
            self.dayLabel.textColor = [UIColor colorWithHex:0x444444];
            
        }else if (self.status == HYYCalendarStatusFuture) {
            self.dayLabel.textColor = [UIColor colorWithHex:0x444444];
            self.userInteractionEnabled = YES;
            
        }else if (self.status == HYYCalendarStatusEmpty) {
            self.backgroundColor = [UIColor whiteColor];
            self.dayLabel.text = nil;
            
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark - Layout
- (void)layoutSubviews {
    
    self.monthLabel.frame = CGRectMake(0, 8, CGRectGetWidth(self.bounds), 20);
    self.dayLabel.frame = CGRectMake(0, CGRectGetMaxY(self.monthLabel.bounds) + 4, CGRectGetWidth(self.bounds), 20);
    if (self.monthLabel.hidden) {
        self.dayLabel.frame = CGRectMake(0,( CGRectGetHeight(self.bounds) - 15 ) / 2., CGRectGetWidth(self.bounds), 20);
    }
}

#pragma mark - Getter
- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:14];
        _dayLabel.textColor = [UIColor colorWithHex:0x888888];
    }
    return _dayLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont systemFontOfSize:10];
        _monthLabel.textColor = [UIColor colorWithHex:0x444444];
    }
    return _monthLabel;
}

@end
