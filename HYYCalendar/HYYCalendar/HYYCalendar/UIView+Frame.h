//
//  UIView+Frame.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/6.
//  Copyright (c) 2015年 zhourx5211. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat frame_x;
@property (assign, nonatomic) CGFloat frame_y;
@property (assign, nonatomic) CGFloat frame_width;
@property (assign, nonatomic) CGFloat frame_height;

@property (assign, nonatomic) CGFloat right;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGSize size;

@end
