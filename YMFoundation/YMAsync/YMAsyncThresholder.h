//
//  YMAsyncThresholder.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/25.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMAsyncBlock.h"

@interface YMAsyncThresholder: NSObject

/**
 *  标记该 Thresholder 已经被解锁，立即执行先前等待的 block， 所有之后的 block 都将立即执行
 */
- (void)unblock;

/**
 *  在若干秒后解锁
 *
 *  @param second 秒
 */
- (void)unblockAfter:(NSTimeInterval)second;

/**
 *  放入一个 block，如果 Thresholder 已经解锁，则立即执行，否则将 block 缓存起来，等稍后执行
 *
 *  @param block block
 */
- (void)queueBlock:(YMVoidBlock __nonnull)block;

@end
