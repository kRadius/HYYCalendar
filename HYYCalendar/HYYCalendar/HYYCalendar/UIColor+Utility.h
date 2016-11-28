//
//  UIColor+Utility.h
//  HYYCalendar
//
//  Created by kRadius on 2016/11/28.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(NSInteger)hexValue addBlack:(CGFloat)black;

@end
