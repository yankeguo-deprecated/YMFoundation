//
//  YMAsyncThresholder.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/25.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMAsyncThresholder.h"

#import "YMAsyncDispatchUtils.h"

@interface YMAsyncThresholder ()

@property(atomic, getter=isBlocking) BOOL blocking;
@property(nonatomic, strong) NSMutableArray<YMVoidBlock> *blocks;

@end

@implementation YMAsyncThresholder

- (instancetype)init {
  if (self = [super init]) {
    self.blocking = YES;
    self.blocks = [NSMutableArray new];
  }
  return self;
}

- (void)queueBlock:(YMVoidBlock)block {
  if (self.isBlocking) {
    [self.blocks addObject:block];
  } else {
    block();
  }
}

- (void)unblock {
  if (!self.blocking) {
    return;
  }
  self.blocking = NO;
  [self.blocks enumerateObjectsUsingBlock:^(YMVoidBlock _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    obj();
  }];
  [self.blocks removeAllObjects];
}

- (void)unblockAfter:(NSTimeInterval)second {
  if (!self.blocking) {
    return;
  }
  __weak typeof(self) _weak_self = self;
  dispatch_main_after(second, ^{
    __strong YMAsyncThresholder *self = _weak_self;
    if (self) {
      [self unblock];
    }
  });
}

@end
