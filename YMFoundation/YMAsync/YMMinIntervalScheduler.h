//
//  YMMinIntervalScheduler.h
//  YMFoundationDemo
//
//  Created by Yanke Guo on 15/12/8.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMMinIntervalScheduler: NSObject

/**
 *  时间间隔
 */
@property(nonatomic, assign, readonly) NSTimeInterval interval;

/**
 *  初始化一个对象
 */
- (instancetype __nonnull)initWithInterval:(NSTimeInterval)interval;
+ (instancetype __nonnull)schedulerWithInterval:(NSTimeInterval)interval;

/**
 *  更新上次调用时间, 用来进行重新计算
 */
- (void)updateLastScheduled;

/**
 *  尝试执行代码,并不会更新内置计时
 */
- (BOOL)schedule:(void (^ __nonnull)())block;

@end
