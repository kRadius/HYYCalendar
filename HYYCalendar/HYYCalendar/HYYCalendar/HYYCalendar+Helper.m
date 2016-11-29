//
//  HYYCalendar+Helper.m
//  HYYCalendar
//
//  Created by kRadius on 2016/11/28.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "HYYCalendar+Helper.h"

@implementation HYYCalendar (Helper)

- (NSString *)unitStringWithUnit:(HYYCalendarUnit)unit {
    
    if (unit == HYYCalendarUnitDay) {
       return @"天";
    } else if (unit == HYYCalendarUnitWeek) {
        return @"周";
    } else if (unit == HYYCalendarUnitMonth) {
        return @"月";
    }
    return nil;
}

@end
