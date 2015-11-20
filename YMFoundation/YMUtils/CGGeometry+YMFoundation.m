//
// Created by Yanke Guo on 15/11/20.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "CGGeometry+YMFoundation.h"

CGPoint CGRectGetCenter(CGRect rect) {
  return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGSize CGSizeAspectFill(CGSize target, CGSize source) {
  CGFloat targetRatio = target.width / target.height;
  CGFloat sourceRatio = source.width / source.height;

  if (targetRatio > sourceRatio) {
    CGFloat widthScale = target.width / source.width;
    return CGSizeMake(target.width, source.height * widthScale);
  } else {
    CGFloat heightScale = target.height / source.height;
    return CGSizeMake(source.width * heightScale, target.height);
  }
}

CGSize CGSizeScale(CGSize source, CGFloat scale) {
  return CGSizeMake(source.width * scale, source.height * scale);
}
