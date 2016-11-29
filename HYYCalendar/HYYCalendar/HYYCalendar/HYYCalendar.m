//
//  HYYCalendar.m
//  CalendarDemo
//
//  Created by kRadius on 16/5/12.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "HYYCalendar.h"
//View
#import "HYYCalendarCollectionView.h"
#import "HYYCalendarPickerView.h"
//Model

//Category
#import "NSDate+Agenda.h"
#import "UIColor+Utility.h"
#import "UIView+Frame.h"
#import "NSDate+Agenda.h"
#import "UIImage+Utility.h"

@interface HYYCalendar () <UIGestureRecognizerDelegate>
//data
@property (strong, nonatomic) NSMutableArray *daysArray;
@property (strong, nonatomic) NSMutableArray *monthsArray;

@property (strong, nonatomic) NSDate *selectedDate;

@property (assign, nonatomic) HYYCalendarUnit unit;
@property (assign, nonatomic) NSUInteger number;
    
//view
@property (strong, nonatomic) HYYCalendarCollectionView *calendarView;
@property (strong, nonatomic) HYYCalendarPickerView *pickerView;

@property (strong, nonatomic) UIView *switchContainer;
@property (strong, nonatomic) UIButton *collectionBtn;
@property (strong, nonatomic) UIButton *pickerBtn;

@end

@implementation HYYCalendar

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    //默认一天后
    return [self initWithFrame:frame number:1 unit:1 type:HYYCalendarTypeCollection];
}

- (instancetype)initWithFrame:(CGRect)frame number:(NSUInteger)number unit:(HYYCalendarUnit)unit type:(HYYCalendarType)type{
    if (self = [super initWithFrame:frame]) {

        _calendarType = type;
        _number = number;
        _unit = unit;
        
        //计算date
        NSUInteger unit2Second = 0;
        switch (unit) {
            case HYYCalendarUnitDay:
                unit2Second = kTimeIntervalDay * number;
                break;
            case HYYCalendarUnitWeek:
                unit2Second = kTimeIntervalWeek * number;
                break;
            case HYYCalendarUnitMonth:
                unit2Second = kTimeIntervalMonth * number;
                break;
        }
        
        NSDate *date = [[[NSDate date] startingDate] dateByAddingTimeInterval:unit2Second];
        _selectedDate = date;
        
        [self p_initViewWithSelectedIndex:number];
        
        if (type == HYYCalendarTypeCollection) {
            [self collectionBtnClicked:nil];
        } else {
//            if ((unit == 1 && number > 30) || (unit == 2 && number > 10) || (unit == 3 && number > 24)) {
//                [self pickerBtnClicked:nil];
//            } else {
//            }
            [self pickerBtnClicked:nil];
        }
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)p_initViewWithSelectedIndex:(NSInteger)selectedIndex {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];;
    
    NSDate *twoYearLater = [[[NSDate date] startingDate] dateByAddingTimeInterval:(24 * kTimeIntervalMonth)];
    
    //collectionView
    self.calendarView = [[HYYCalendarCollectionView alloc] initWithFrame:CGRectMake(0, 112, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 112) fromDate:[NSDate date] toDate:twoYearLater];
    self.calendarView.selectedDate = self.selectedDate;
    self.calendarView.defaultSelectedIndex = selectedIndex;
    
    //picker
    self.pickerView = [[HYYCalendarPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 212 - 45, CGRectGetWidth(self.bounds), 212) number:_number unit:_unit];
//    self.pickerView.selectedDate = _selectedDate;
    self.pickerView.alpha = 0;
    
    [self addSubview:self.pickerView];
    [self addSubview:self.calendarView];
    [self addSubview:self.switchContainer];
    
    __weak typeof(self) weakSelf = self;
    self.calendarView.calendarCallback = ^(NSDate *date, NSUInteger number) {
        [weakSelf hide];
        if ([weakSelf.delegate respondsToSelector:@selector(calendar:didSelectDate:number:unit:)]) {
            [weakSelf.delegate calendar:weakSelf didSelectDate:date number:number unit:1];
        }
    };
    
    self.pickerView.pickerCallback = ^(NSDate *date, NSUInteger number, NSUInteger unit) {
        [weakSelf hide];
        if ([weakSelf.delegate respondsToSelector:@selector(calendar:didSelectDate:number:unit:)]) {
            [weakSelf.delegate calendar:weakSelf didSelectDate:date number:number unit:unit];
        }
    };
}

#pragma mark - UIGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[HYYCalendar class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - Action
- (void)collectionBtnClicked:(UIButton *)sender {

    _calendarType = HYYCalendarTypeCollection;
    
    if (sender) {
        [UIView animateWithDuration:.25 animations:^{
            _pickerView.alpha = 0;
            _calendarView.alpha = 1;
        }];
    } else {
        _pickerView.alpha = 0;
        _calendarView.alpha = 1;
    }
    self.collectionBtn.selected = YES;
    self.pickerBtn.selected = NO;
}
- (void)pickerBtnClicked:(UIButton *)sender {

    _calendarType = HYYCalendarTypePicker;
    if (sender) {
        [UIView animateWithDuration:.25 animations:^{
            _pickerView.alpha = 1;
            _calendarView.alpha = 0;
        }];
    } else {
        _pickerView.alpha = 1;
        _calendarView.alpha = 0;
    }
    
    self.collectionBtn.selected = NO;
    self.pickerBtn.selected = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self hide];
}

- (void)show {
    UIView *view = self.collectionBtn.selected ? self.calendarView : self.pickerView;
    CGFloat origin = view.frame.origin.y;
    view.frame_y = self.frame_height;
    [UIView animateWithDuration:0.25 animations:^{
        view.frame_y = origin;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - getter
- (UIView *)switchContainer {
    if (!_switchContainer) {
        _switchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 45, CGRectGetWidth(self.bounds), 45)];
        
        //日期
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame = CGRectMake(0, 0, CGRectGetWidth(_switchContainer.bounds) / 2., CGRectGetHeight(_switchContainer.bounds));
        [collectionBtn setTitle:@"日期" forState:UIControlStateNormal];
        
        [collectionBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
        [collectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [collectionBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.96] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [collectionBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x38b8c1] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [collectionBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xe5e5e5] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        
        [collectionBtn addTarget:self action:@selector(collectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_switchContainer addSubview:collectionBtn];
        
        self.collectionBtn = collectionBtn;
        
        //天/周/日
        UIButton *pickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pickerBtn.frame = CGRectMake(CGRectGetWidth(_switchContainer.bounds) / 2., 0, CGRectGetWidth(_switchContainer.bounds) / 2., CGRectGetHeight(_switchContainer.bounds));
        [pickerBtn setTitle:@"天/周/月" forState:UIControlStateNormal];
        
        [pickerBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
        [pickerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [pickerBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.96] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [pickerBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x38b8c1] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [pickerBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xe5e5e5] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        
        [pickerBtn addTarget:self action:@selector(pickerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_switchContainer addSubview:pickerBtn];
        self.pickerBtn = pickerBtn;
    }
    return _switchContainer;
}


@end
