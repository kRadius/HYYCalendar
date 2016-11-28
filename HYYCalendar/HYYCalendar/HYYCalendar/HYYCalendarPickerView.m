//
//  HYYCalendarPickerView.m
//  CalendarDemo
//
//  Created by kRadius on 16/5/13.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "HYYCalendarPickerView.h"

//Category
#import "UIColor+Utility.h"
#import "NSDate+Agenda.h"

const NSUInteger kTimeIntervalDay = 3600 * 24;
const NSUInteger kTimeIntervalWeek = kTimeIntervalDay * 7;
const NSUInteger kTimeIntervalMonth = kTimeIntervalDay * 30;

@interface HYYCalendarPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) NSString *selectedDateStr;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) NSUInteger defaultNumber;
@property (assign, nonatomic) NSUInteger defaultUnit;

@end

@implementation HYYCalendarPickerView

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame number:1 unit:1];
}

- (instancetype)initWithFrame:(CGRect)frame number:(NSUInteger)number unit:(NSUInteger)unit{
    if (self = [super initWithFrame:frame]) {
        _defaultNumber = number;
        _defaultUnit = unit;

        self.backgroundColor = [UIColor whiteColor];
        [self p_initView];
    }
    return self;
}

- (void)p_initView {
    [self addSubview:self.headerView];
    [self addSubview:self.pickerView];
    
    NSUInteger dateType = _defaultUnit - 1;
    NSInteger number = _defaultNumber;
    
    if (dateType == 0) {
        self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:number * kTimeIntervalDay];
    } else if (dateType == 1) {
        self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:number * kTimeIntervalWeek];
    } else {
        self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:number * kTimeIntervalMonth];
    }
    NSString *typeString = @[@"天",@"周",@"月"][dateType];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld%@后 (%@)",number,typeString,self.selectedDateStr];
    
}

#pragma mark - Delegate
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 1) {
        return 3;
    } else if (component == 0 && pickerView.numberOfComponents > 1) {
        if ([pickerView selectedRowInComponent:1] == 0) {
            return 30;
        } else if ([pickerView selectedRowInComponent:1] == 1) {
            return 10;
        } else if ([pickerView selectedRowInComponent:1] == 2) {
            return 24;
        }
    }
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.minimumScaleFactor = .5;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:19]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld",row+1];
    } else {
        return @[@"天",@"周",@"月"][row];
    }
    return @"1";
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36.f;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger number = row + 1;
    //选中的是类型
    if (component == 1) {
        number = [pickerView selectedRowInComponent:0] + 1;
    }
    
    NSUInteger dateType = [pickerView selectedRowInComponent:1];
    
    if (dateType == 0) {
        self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:number * kTimeIntervalDay];
    } else if (dateType == 1) {
        self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:number * kTimeIntervalWeek];
    } else {
        self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:number * kTimeIntervalMonth];
    }
    NSString *typeString = @[@"天",@"周",@"月"][dateType];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld%@后 (%@)",number,typeString,self.selectedDateStr];
    
    if (component == 1) {
        [pickerView reloadComponent:0];
    }
}

#pragma mark - Action
- (void)confirmBtnClicked:(UIButton *)sender {
    if (self.pickerCallback) {
        NSUInteger days = [self.pickerView selectedRowInComponent:0] + 1;
        NSUInteger unit = [self.pickerView selectedRowInComponent:1] + 1;
        self.pickerCallback(self.selectedDate,days,unit);
    }
}

#pragma mark - Setter
- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    self.selectedDateStr = [_selectedDate dateStringWithFormat:@"yyyy-MM-dd"];
    
    //多少天后
    self.dateLabel.text = self.selectedDateStr;
}


#pragma mark - Getter
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 42, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 42)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_pickerView selectRow:_defaultNumber - 1 inComponent:0 animated:NO];
        [_pickerView selectRow:_defaultUnit - 1 inComponent:1 animated:NO];

    }
    return _pickerView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 42)];
        _headerView.backgroundColor = [UIColor whiteColor];
        //label
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(_headerView.bounds) - 15 - 70, CGRectGetHeight(_headerView.bounds))];
        self.dateLabel.textColor = [UIColor colorWithHex:0x444444];
        self.dateLabel.font = [UIFont systemFontOfSize:16];
        [_headerView addSubview:self.dateLabel];
        
        //确定按钮
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 70, 0, 70, 45);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor colorWithHex:0x38b8c1] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:confirmBtn];
        
    }
    return _headerView;
}

@end
