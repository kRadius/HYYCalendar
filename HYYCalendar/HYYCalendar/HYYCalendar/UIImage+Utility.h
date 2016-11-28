//
//  UIImage+Utility.h
//  HYYCalendar
//
//  Created by kRadius on 2016/11/28.
//  Copyright © 2016年 kRadius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

///创建纯色的图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
///创建纯色的圆形图片
+ (UIImage *)imageWithColor:(UIColor *)color radius:(CGFloat)radius;

@end
