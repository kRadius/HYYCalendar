//
//  HYYCalendarCollectionHeaderView.h
//  CalendarDemo
//
//  Created by kRadius on 16/5/13.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYYCalendarCollectionHeaderView : UIView

@property (strong, nonatomic) NSString *dateStr;

@property (copy, nonatomic) dispatch_block_t callback;

@end
