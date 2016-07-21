//
//  YMUtilsSystemInfo.m
//  YMFoundationDemo
//
//  Created by Yanke Guo on 15/12/8.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "YMUtilsSystemInfo.h"

#import "YMLogger.h"

#import <mach/mach_time.h>

uint64_t YMGetDeviceUptimeInMilliseconds() {
  const int64_t kOneMillion = 1000 * 1000;
  static mach_timebase_info_data_t s_timebase_info;

  if (s_timebase_info.denom == 0) {
    (void) mach_timebase_info(&s_timebase_info);
  }

  // mach_absolute_time() returns billionth of seconds,
  // so divide by one million to get milliseconds
  return ((mach_absolute_time() * s_timebase_info.numer) / (kOneMillion * s_timebase_info.denom));
}

void     YMTimeProfile(NSString * __nonnull name, void(^block)()) {
  uint64_t start = YMGetDeviceUptimeInMilliseconds();
  if (block) block();
  uint64_t diff  = YMGetDeviceUptimeInMilliseconds() - start;
  DLog(@"[YMTimeProfile] %@: %ld", name, diff);
}
