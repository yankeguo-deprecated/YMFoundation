//
//  YMMinIntervalScheduler.m
//  YMFoundationDemo
//
//  Created by Yanke Guo on 15/12/8.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "YMMinIntervalScheduler.h"

#import "YMUtilsSystemInfo.h"
#import "YMAsyncDispatchUtils.h"

@interface YMMinIntervalScheduler () {
  uint64_t _lastScheduled;
}

@end

@implementation YMMinIntervalScheduler

- (instancetype)initWithInterval:(NSTimeInterval)interval {
  self = [super init];
  if (self) {
    NSParameterAssert(interval > 0);
    _lastScheduled = 0;
    _interval = interval;
  }
  return self;
}

+ (instancetype)schedulerWithInterval:(NSTimeInterval)interval {
  return [[self alloc] initWithInterval:interval];
}

- (void)updateLastScheduled {
  _lastScheduled = YMGetDeviceUptimeInMilliseconds();
}

- (void)clearLastScheduled {
  _lastScheduled = 0;
}

- (BOOL)schedule:(void (^ __nonnull)())block {
  // Be warned, _lastScheduled == 0 means never scheduled, should be treated separately in case of app launching shortly after device turned on.
  if (_lastScheduled == 0) {
    block_safe_invoke(block);
    return YES;
  }

  if ((YMGetDeviceUptimeInMilliseconds() - _lastScheduled) > (_interval * 1000)) {
    block_safe_invoke(block);
    return YES;
  }

  return NO;
}

@end
