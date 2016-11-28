//
//  HYYCalendarCollectionView.m
//  CalendarDemo
//
//  Created by kRadius on 16/5/12.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "HYYCalendarCollectionView.h"
#import "HYYCalendarCollectionHeaderView.h"
#import "HYYCalendarDayCell.h"

#import "HYYCalendarLayout.h"

//Category
#import "NSDate+Agenda.h"
#import "UIColor+Utility.h"

//ReuseId
static NSString *const kCalendarCellReuseIde = @"HYYCalendarCollectionViewCellRuseIde";

@interface HYYCalendarCollectionView () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {

}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) HYYCalendarCollectionHeaderView *headerView;
//蒙层
@property (strong, nonatomic) UIView *dateIndicatorView;

@property (strong, nonatomic) NSString *selectedDateStr;

@property (assign, nonatomic) NSUInteger day;

@property (assign, nonatomic) BOOL updated;

//-----------
@property (strong, nonatomic) NSDate *fromeDate;
@property (strong, nonatomic) NSDate *toDate;
@property (strong, nonatomic) NSDate *firstDayOfMonth;

@end


@implementation HYYCalendarCollectionView

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame fromDate:(NSDate *)fromeDate toDate:(NSDate *)toDate {
    if (self = [super initWithFrame:frame]) {
        _fromeDate = fromeDate;
        _toDate = toDate;
        
        self.firstDayOfMonth = [_fromeDate firstDayOfTheMonth];
        
        [self p_initView];
    }
    return self;
}

- (void)p_initView {
    [self addSubview:self.headerView];
    [self addSubview:self.collectionView];
    
    [self.collectionView addSubview:self.dateIndicatorView];
    
    __weak typeof(self) weakSelf = self;
    //确定按钮点击
    self.headerView.callback = ^{
        
        if (weakSelf.calendarCallback) {
            weakSelf.calendarCallback(weakSelf.selectedDate,weakSelf.day);
        }
    };
    
}

#pragma mark - Private
- (NSDate *)dateAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger weekDay = [self.firstDayOfMonth weekDay] - 1;
    if (indexPath.row < weekDay) {
        return nil;
    }
    
    NSDate *dateToReturn = [self.firstDayOfMonth dateByAddingTimeInterval:(indexPath.row - weekDay) * 3600 * 24];
    return dateToReturn;
}

#pragma mark - Delegate
#pragma mark - UICollectionView DataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = floor(CGRectGetWidth(self.collectionView.bounds) / 7.0);
    int num = (int)(CGRectGetWidth(self.collectionView.bounds)) % 7;
    if ((indexPath.row % 7) < num) {
        width += 1;
    }
    return CGSizeMake(width, 47);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger weekDay = [self.firstDayOfMonth weekDay] - 1;
    
    return [NSDate numberOfDaysFromDate:self.fromeDate toDate:self.toDate] + weekDay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYYCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarCellReuseIde forIndexPath:indexPath];

    NSDate *cellDate = [self dateAtIndexPath:indexPath];
    if (!cellDate) {
        cell.status = HYYCalendarStatusEmpty;
    } else {
        
        //今天
        if ([cellDate isToday]) {
            cell.status = HYYCalendarStatusToday;
            
        } else if([cellDate isLaterThanDate:self.fromeDate]) {
            //将来
            cell.status = HYYCalendarStatusFuture;
            
        } else if([cellDate isEarlierThanDate:self.fromeDate]) {
            //过去
            cell.status = HYYCalendarStatusPast;
        }
        
        //第一天
        cell.firstDayInCurMonth = NO;
        if ([cellDate dayComponents] == 1) {
            cell.firstDayInCurMonth = YES;
        }
        //选中
        cell.mySelected = NO;
        if ([cellDate isEqualToDateIgnoringTime:self.selectedDate]) {
            cell.mySelected = YES;
        }
        //背景色
        cell.sameColorWithCurMonth = !(labs([cellDate monthComponents] - [self.fromeDate monthComponents]) % 2);
    }
    
    [cell updateContentWithDate:cellDate];
    
    return cell;
}


#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger empty = [self.firstDayOfMonth weekDay] - 1;
    self.selectedDate = [self.firstDayOfMonth dateByAddingTimeInterval:(indexPath.row - empty) * 24 * 3600];

    [self.collectionView reloadData];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self updateDateIndicator];
    
    [UIView animateWithDuration:.25f animations:^{
        self.dateIndicatorView.alpha = 1;
    }];
}

- (void)updateDateIndicator {
    //节省计算
    if (self.updated) {
        return;
    }
    self.updated = YES;
    self.dateIndicatorView.frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.bounds), self.collectionView.contentSize.height);
    [self.collectionView bringSubviewToFront:self.dateIndicatorView];
    
    NSArray *subviews = self.dateIndicatorView.subviews;
    
    CGFloat space = 50;
    CGFloat topOffset = 30;
    CGFloat height = (CGRectGetHeight(_dateIndicatorView.bounds) - 25 * space )/ 24;
    
    [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, topOffset * (1 + idx /24.) + space + idx * (height + space), CGRectGetWidth(_dateIndicatorView.bounds), height);
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        return;
    }
    [UIView animateWithDuration:.25f animations:^{
        self.dateIndicatorView.alpha = 0;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [UIView animateWithDuration:.25f animations:^{
        self.dateIndicatorView.alpha = 0;
    }];
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        HYYCalendarLayout *layout = [[HYYCalendarLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 60) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
        
        [_collectionView registerClass:[HYYCalendarDayCell class] forCellWithReuseIdentifier:kCalendarCellReuseIde];
    }
    return _collectionView;
}

- (HYYCalendarCollectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HYYCalendarCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 60)];
    }
    return _headerView;
}
#pragma mark - Setter
- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    
    NSString *dateStr = [_selectedDate dateStringWithFormat:@"yyyy-MM-dd"];
    //多少天后
    _day = [NSDate numberOfDaysFromDate:[NSDate date] toDate:selectedDate];
    
    NSString *distanceDay = [NSString stringWithFormat:@"%ld天后 ",_day];
    if (!_day) {
        distanceDay = @" (今天)";
    }

    self.selectedDateStr = [distanceDay stringByAppendingFormat:@"(%@)",dateStr];
    self.headerView.dateStr = self.selectedDateStr;
}

#pragma mark - Getter
- (UIView *)dateIndicatorView {
    if (!_dateIndicatorView) {
        
        _dateIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.collectionView.bounds), self.collectionView.contentSize.height)];

        _dateIndicatorView.backgroundColor = [UIColor colorWithWhite:1 alpha:.88];
        _dateIndicatorView.alpha = 1;
        
        NSInteger month = [NSDate numberOfMonthFromDate:self.firstDayOfMonth toDate:self.toDate];
        
        for (int i = 0; i < month; i ++) {
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            dateLabel.textColor = [UIColor colorWithHex:0x444444];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.font = [UIFont systemFontOfSize:20];
            
            NSInteger year = [self.firstDayOfMonth yearComponents] + ([self.firstDayOfMonth monthComponents] + i) / 12;
            NSInteger month = ([self.firstDayOfMonth monthComponents] + i) % 12;
            if (month == 0) {
                month = 12;
            }
            
            dateLabel.text = [NSString stringWithFormat:@"%ld年%ld月",year, month];
            
            [_dateIndicatorView addSubview:dateLabel];
        }
    }
    return _dateIndicatorView;
}

#pragma mark - Setter
- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex {
    _defaultSelectedIndex = defaultSelectedIndex;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_defaultSelectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
}

@end


