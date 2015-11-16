//
//  YMAsyncQueue.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/10/12.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YMAsyncQueueReleaseBlock)();
typedef void(^YMAsyncQueueStartBlock)();
typedef void(^YMAsyncQueueDrainBlock)();
typedef void(^YMAsyncQueueBlock)(YMAsyncQueueReleaseBlock __nonnull releaseBlock);

@interface YMAsyncQueue: NSObject

/**
 *  Max count of blocks can be queued, 0 for unlimited
 */
@property(nonatomic, assign) NSUInteger maxLength;

/**
 *  Timeout of execution of a single block queued, 0 for never
 */
@property(nonatomic, assign) NSTimeInterval timeout;

/**
 *  A block to execute when this YMAsyncQueue bacome running
 */
@property(nonatomic, copy) YMAsyncQueueStartBlock __nullable startBlock;

/**
 *  A block to execute when this YMAsyncQueue become drain
 */
@property(nonatomic, copy) YMAsyncQueueDrainBlock __nullable drainBlock;

/**
 *  Create a instance
 *
 *  @return a sharedLocale
 */
+ (instancetype __nonnull)queue;

/**
 *  Create a instance
 *
 *  @return a sharedLocale
 */
- (instancetype __nonnull)init;

/**
 *  Run a block on this YMAsyncQueue
 *
 *  @param block block to execute
 *
 *  @param name the name of block, will appear in log if timeout exceeded etc.
 *
 *  @return BOOL whether the block is queued, if maxLength reached, return NO
 */

- (BOOL)run:(YMAsyncQueueBlock __nonnull)block name:(NSString *__nullable)name;

/**
 *  Same as above, use block's pointer address as name
 *
 *  @param block block to execute
 *
 *  @return BOOL, see above
 */
- (BOOL)run:(YMAsyncQueueBlock __nonnull)block;

@end
