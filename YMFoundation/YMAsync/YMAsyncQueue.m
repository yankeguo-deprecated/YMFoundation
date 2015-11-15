//
//  YMAsyncQueue.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/10/12.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMAsyncQueue.h"

#import "YMAsyncBlockUtils.h"
#import "YMAsyncDispatchUtils.h"
#import "YMLogger.h"

#define YMAsyncQueueIsEpsilon(VALUE) (VALUE <= DBL_MIN)

#pragma mark - YMAsyncQueue

@interface YMAsyncQueue ()

/**
 *  Array of YMAsyncQueueBlock to be executed
 */
@property(nonatomic, strong) NSMutableArray<YMAsyncQueueBlock> *queue;

/**
 *  Array of block names
 */
@property(nonatomic, strong) NSMutableArray<NSString *> *blockNames;

/**
 *  A flag indicate whether queue is already running
 */
@property(nonatomic, assign) BOOL runningFlag;

@end

@implementation YMAsyncQueue

+ (instancetype)queue {
  return [[[self class] alloc] init];
}

- (instancetype)init {
  if (self = [super init]) {
    self.runningFlag = NO;
    self.maxLength = 0;
    self.queue = [NSMutableArray new];
    self.blockNames = [NSMutableArray new];
  }
  return self;
}

- (BOOL)run:(YMAsyncQueueBlock)block {
  return [self run:block name:nil];
}

- (BOOL)run:(YMAsyncQueueBlock)block name:(NSString *)name {
  //  Check if maxLength exceeded
  if (self.maxLength > 0 && self.queue.count >= self.maxLength) { return NO; }

  //  Use pointer address as block name if name is nil
  if (name == nil) { name = [NSString stringWithFormat:@"%p", block]; }

  //  Add the block and its name
  [self.queue addObject:block];
  [self.blockNames addObject:name];

  DLog(@"[YMAsyncQueue] block queued: %@", name);

  //  Run the queue
  [self runQueue];

  return YES;
}

- (void)runQueue {
  //  Check if the queue is already running
  if (self.runningFlag) {
    return;
  }

  //  Run the queue for real
  [self _runQueue];
}

- (void)_runQueue {
  //  Check if the queue is drain
  if (self.queue.count == 0) {
    //  Execute the drainBlock
    YMAsyncQueueDrainBlock drainBlock = self.drainBlock;
    if (drainBlock) { drainBlock(); }

    //  Clear the runningFlag and return
    self.runningFlag = NO;
    return;
  }

  //  Set the runningFlag
  self.runningFlag = YES;

  //  Execute the startBlock
  YMAsyncQueueStartBlock startBlock = self.startBlock;
  if (startBlock) { startBlock(); }

  //  Take out the block and its name
  YMAsyncQueueBlock block = [self.queue objectAtIndex:0];
  NSString *blockName = [self.blockNames objectAtIndex:0];

  //  Put the current timeout to local variable
  NSTimeInterval timeout = self.timeout;

  //  Prepare the releaseBlock
  __weak typeof(self) _weak_self = self;
  YMAsyncQueueReleaseBlock releaseBlock = ^{
    dispatch_async_main_alt(^{
      __strong YMAsyncQueue *self = _weak_self;
      [self.queue removeObjectAtIndex:0];
      [self.blockNames removeObjectAtIndex:0];
      [self _runQueue];
    });
  };

  //  If there is a timeout set
  if (!YMAsyncQueueIsEpsilon(timeout)) {

    //  Create a once-block for releaseBlock
    YMAsyncBOOLBlock block1 = YMAsyncCreateOnceBlock(releaseBlock);

    //  invoke block1 for timeout
    dispatch_main_after(timeout, ^{
      if (block1()) {
        ELog(@"[YMAsyncQueue] block expired: %@", blockName);
      }
    });

    //  invoke block2 for block execution
    dispatch_async_main_alt(^{
      block(^{
        if (block1()) {
          DLog(@"[YMAsyncQueue] block releaseBlock called: %@", blockName);
        }
      });
    });

  } else {

    //  Execute the block, passing the releaseBlock in
    dispatch_async_main_alt(^{
      block(^{
        DLog(@"[YMAsyncQueue] block releaseBlock called: %@", blockName);
        releaseBlock();
      });
    });

  }
}

@end
