//
// Created by Yanke Guo on 15/11/17.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "UIView+YMEasyFrame.h"

@implementation UIView (MGEasyFrame)

#pragma mark - Setters

- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
  CGSize size = self.size;
  size.width = width;
  self.size = size;
}

- (void)setHeight:(CGFloat)height {
  CGSize size = self.size;
  size.height = height;
  self.size = size;
}

- (void)setOrigin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}

- (void)setX:(CGFloat)x {
  CGPoint origin = self.origin;
  origin.x = x;
  self.origin = origin;
}

- (void)setY:(CGFloat)y {
  CGPoint origin = self.origin;
  origin.y = y;
  self.origin = origin;
}

- (void)setLeft:(CGFloat)left {
  CGPoint origin = self.origin;
  origin.x = left;
  self.origin = origin;
}

- (void)setTop:(CGFloat)top {
  CGPoint origin = self.origin;
  origin.y = top;
  self.origin = origin;
}

- (void)setBottom:(CGFloat)bottom {
  CGPoint origin = self.origin;
  origin.y = bottom - self.height;
  self.origin = origin;
}

- (void)setRight:(CGFloat)right {
  CGPoint origin = self.origin;
  origin.x = right - self.width;
  self.origin = origin;
}

- (void)setTopLeft:(CGPoint)topLeft {
  self.origin = topLeft;
}

- (void)setTopCenter:(CGPoint)topCenter {
  CGPoint origin = self.origin;
  origin.x = topCenter.x - self.width / 2;
  origin.y = topCenter.y;
  self.origin = origin;
}

- (void)setTopRight:(CGPoint)topRight {
  CGPoint origin = self.origin;
  origin.x = topRight.x - self.width;
  origin.y = topRight.y;
  self.origin = origin;
}

- (void)setBottomLeft:(CGPoint)bottomLeft {
  CGPoint origin = self.origin;
  origin.x = bottomLeft.x;
  origin.y = bottomLeft.y - self.height;
  self.origin = origin;
}

- (void)setBottomCenter:(CGPoint)bottomCenter {
  CGPoint origin = self.origin;
  origin.x = bottomCenter.x - self.width / 2;
  origin.y = bottomCenter.y - self.height;
  self.origin = origin;
}

- (void)setBottomRight:(CGPoint)bottomRight {
  CGPoint origin = self.origin;
  origin.x = bottomRight.x - self.width;
  origin.y = bottomRight.y - self.height;
  self.origin = origin;
}

- (void)setLeftCenter:(CGPoint)leftCenter {
  CGPoint origin = self.origin;
  origin.x = leftCenter.x;
  origin.y = leftCenter.y - self.height / 2;
  self.origin = origin;
}

- (void)setRightCenter:(CGPoint)rightCenter {
  CGPoint origin = self.origin;
  origin.y = rightCenter.y - self.height / 2;
  origin.x = rightCenter.x - self.width;
  self.origin = origin;
}

#pragma mark - Getters

- (CGSize)size {
  return self.frame.size;
}

- (CGFloat)width {
  return self.size.width;
}

- (CGFloat)height {
  return self.size.height;
}

- (CGPoint)origin {
  return self.frame.origin;
}

- (CGFloat)x {
  return self.origin.x;
}

- (CGFloat)y {
  return self.origin.y;
}

- (CGFloat)left {
  return self.origin.x;
}

- (CGFloat)top {
  return self.origin.y;
}

- (CGFloat)bottom {
  return self.origin.y + self.size.height;
}

- (CGFloat)right {
  return self.origin.x + self.size.width;
}

- (CGPoint)topLeft {
  return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
}

- (CGPoint)topCenter {
  return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
}

- (CGPoint)topRight {
  return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
}

- (CGPoint)bottomRight {
  return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
}

- (CGPoint)bottomCenter {
  return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
}

- (CGPoint)bottomLeft {
  return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
}

- (CGPoint)leftCenter {
  return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame));
}

- (CGPoint)rightCenter {
  return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame));
}

@end
