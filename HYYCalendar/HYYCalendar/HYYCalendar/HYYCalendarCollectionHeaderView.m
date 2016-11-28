//
//  HYYCalendarCollectionHeaderView.m
//  CalendarDemo
//
//  Created by kRadius on 16/5/13.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "HYYCalendarCollectionHeaderView.h"
//Category
#import "UIColor+Utility.h"

#define OnePixel (1.0 / [UIScreen mainScreen].scale)

@interface HYYCalendarCollectionHeaderView ()

@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation HYYCalendarCollectionHeaderView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_initView];
    }
    return self;
}

- (void)p_initView {
    self.backgroundColor = [UIColor whiteColor];
    
    //label
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bounds) - 15 - 70, 45)];
    self.dateLabel.textColor = [UIColor colorWithHex:0x444444];
    self.dateLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.dateLabel];
    
    
    //确定按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 70, 0, 70, 45);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHex:0x38b8c1] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    //线
    CALayer *topLine = [[CALayer alloc] init];
    topLine.frame = CGRectMake(0, 45, CGRectGetWidth(self.bounds), OnePixel);
    topLine.backgroundColor = [UIColor colorWithHex:0xeaeaea].CGColor;
    [self.layer addSublayer:topLine];
    
    
    //日期
    NSArray *weekDay = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    [weekDay enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = CGRectGetWidth(self.bounds) / weekDay.count;
        CGFloat height = 15.;
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(idx * width, CGRectGetMaxY(topLine.frame), width, height)];
        weekLabel.font = [UIFont systemFontOfSize:10];
        weekLabel.textColor = [UIColor colorWithHex:0xAAAAAA];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        if (idx == weekDay.count - 1 || idx == weekDay.count - 2) {
            weekLabel.textColor = [UIColor colorWithHex:0xFFA8B1];
        }
        weekLabel.text = obj;
        [self addSubview:weekLabel];
    }];
    
    //线
    CALayer *bottomLine = [[CALayer alloc] init];
    bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - OnePixel, CGRectGetWidth(self.bounds), OnePixel);
    bottomLine.backgroundColor = [UIColor colorWithHex:0xeaeaea].CGColor;
    [self.layer addSublayer:bottomLine];
}

#pragma mark - Action
- (void)confirmBtnClicked:(UIButton *)sender {
    if (self.callback) {
        self.callback();
    }
}

#pragma mark - Setter
- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    self.dateLabel.text = _dateStr;
}

@end
