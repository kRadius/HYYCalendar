//
//  HYYCalendarLayout.m
//  CalendarDemo
//
//  Created by kRadius on 16/5/12.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "HYYCalendarLayout.h"

@implementation HYYCalendarLayout

- (instancetype)init {
    if (self = [super init]) {
        
        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 7., 46.5f);//每个cell的大小
        
        self.minimumLineSpacing = 0.0f;//每行的最小间距
        
        self.minimumInteritemSpacing = 0.0f;//每列的最小间距
        
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//网格视图的/上/左/下/右,的边距
        
    }
    return self;
}

@end
