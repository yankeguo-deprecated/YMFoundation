//
//  YMAsyncBlock.h
//
//  Created by Yanke Guo on 15/11/13.
//  Copyright © 2015年 YMXian. All rights reserved.
//
//  Basic block types used in YMAsyncKit.

#import <Foundation/Foundation.h>

#pragma mark - Basic block types

/**
 *  Block accept void, returns void
 */
typedef void (^YMVoidBlock)();

/**
 *  Block accept void, returns BOOL
 *
 *  @return BOOL
 */
typedef BOOL (^YMBOOLBlock)();

/**
 *  Block accept void, returns NSComparisonResult
 *
 *  @return NSComparisonResult
 */
typedef NSComparisonResult (^YMCompareBlock)();

/**
 *  General purposed callback block
 *
 *  @param error error object if any error occured
 */
typedef void (^YMErrorBlock)(NSError *__nullable error);

/**
 *  General purposed operation block, accept a YMAsyncCallbackBlock as input
 *
 *  @param callback YMAsyncCallbackBlock, shall be invoked when operation finished
 */
typedef void (^YMAsyncOperationBlock)(YMErrorBlock __nonnull callback);

#pragma mark - Basic block macros

/**
 *  Invoke a block if block not nil
 *
 *  @param BLOCK block or nil
 *  @param ...   block arguments
 */
#define block_safe_invoke(BLOCK, ...)  if (BLOCK) { BLOCK(__VA_ARGS__); }