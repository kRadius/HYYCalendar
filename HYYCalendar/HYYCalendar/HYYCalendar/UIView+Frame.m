//
//  UIView+Frame.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/6.
//  Copyright (c) 2015年 zhourx5211. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - setter

- (void)setFrame_x:(CGFloat)frame_x {
    CGRect frame = self.frame;
    frame.origin.x = frame_x;
    self.frame = frame;
}

- (void)setFrame_y:(CGFloat)frame_y {
    CGRect frame = self.frame;
    frame.origin.y = frame_y;
    self.frame = frame;
}
- (void)setFrame_width:(CGFloat)frame_width {
    CGRect frame = self.frame;
    frame.size.width = frame_width;
    self.frame = frame;
}
- (void)setFrame_height:(CGFloat)frame_height {
    CGRect frame = self.frame;
    frame.size.height = frame_height;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = ceilf(right - frame.size.width);
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = ceilf(bottom - frame.size.height);
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(ceilf(centerX), self.center.y);
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, ceilf(centerY));
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - getter
- (CGFloat)frame_x {
    return self.frame.origin.x;
}
- (CGFloat)frame_y {
    return self.frame.origin.y;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)frame_width {
    return self.frame.size.width;
}
- (CGFloat)frame_height {
    return self.frame.size.height;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGSize)size {
    return self.frame.size;
}


@end
