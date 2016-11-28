//
//  HYYCalendar+Helper.m
//  HYYCalendar
//
//  Created by kRadius on 2016/11/28.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "HYYCalendar+Helper.h"

@implementation HYYCalendar (Helper)

- (NSString *)unitString {
    NSString *unitString;
    if (self.unit == HYYCalendarUnitDay) {
        unitString = @"天";
    } else if (self.unit == HYYCalendarUnitWeek) {
        unitString = @"周";
    } else if (self.unit == HYYCalendarUnitMonth) {
        unitString = @"月";
    }
    return unitString;
}

@end
