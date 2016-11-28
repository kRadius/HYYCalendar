//
//  UIColor+Utility.m
//  HYYCalendar
//
//  Created by kRadius on 2016/11/28.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)

+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:1];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue addBlack:(CGFloat)black {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16) * (1 - black)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8) * (1 - black)) / 255.0
                            blue:((float)(hexValue & 0xFF) * (1 - black))/255.0
                           alpha:1];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

@end
