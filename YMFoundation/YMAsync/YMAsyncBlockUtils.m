//
//  YMAsyncBlockUtils.m
//
//  Created by Yanke Guo on 15/11/13.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "YMAsyncBlockUtils.h"

#pragma mark - Block manimulate

YMBOOLBlock YMAsyncCreateOnceBlock(YMVoidBlock inputBlock) {
  //  Create a flag
  __block BOOL clean = YES;

  return ^BOOL {
    //  Check the flag
    if (clean) {
      //  Clear the flag
      clean = NO;
      //  Invoke inputBlock
      inputBlock();
      return YES;
    }
    return NO;
  };
}

YMCompareBlock YMAsyncCreateAllBlock(NSUInteger count, YMVoidBlock inputBlock) {
  //  Create a counter
  __block NSUInteger n = 0;

  return ^NSComparisonResult {
    //  Increase the counter
    n++;
    //  Check the counter with count set
    if (n == count) {
      //  Invoke the inputBlock
      inputBlock();
      return NSOrderedSame;
    }
    return n < count ? NSOrderedDescending : NSOrderedAscending;
  };
}