//
//  YMAsyncQueueSpec.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/10/12.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

SpecBegin(YMAsyncQueue)

it(@"should work", ^{
  YMAsyncQueue* queue = [YMAsyncQueue new];
  
  __block BOOL _startCalled = NO;
  __block BOOL _stopCalled  = NO;
  
  queue.startBlock = ^{
    _startCalled = YES;
  };
  
  queue.drainBlock = ^{
    _stopCalled = YES;
  };
  
  __block NSInteger value = 0;
  
  [queue run:^(YMAsyncQueueReleaseBlock  _Nonnull releaseBlock) {
    XCTAssert(_startCalled);
    XCTAssertFalse(_stopCalled);
    dispatch_main_after(1, ^{
      value = 1;
      releaseBlock();
    });
  }];
  
  [queue run:^(YMAsyncQueueReleaseBlock  _Nonnull releaseBlock) {
    XCTAssert(_startCalled);
    XCTAssertFalse(_stopCalled);
    XCTAssert(value == 1);
    dispatch_main_after(1, ^{
      value = 2;
      releaseBlock();
    });
  }];
  
  waitUntil(^(DoneCallback done) {
    dispatch_main_after(3, ^{
      XCTAssert(_stopCalled);
      [queue run:^(YMAsyncQueueReleaseBlock  _Nonnull releaseBlock) {
        XCTAssert(value == 2);
        dispatch_main_after(1, ^{
          value = 1;
          releaseBlock();
        });
      }];
      
      [queue run:^(YMAsyncQueueReleaseBlock  _Nonnull releaseBlock) {
        XCTAssert(value == 1);
        dispatch_main_after(1, ^{
          value = 2;
          releaseBlock();
          done();
        });
      }];
    });
  });
});

SpecEnd