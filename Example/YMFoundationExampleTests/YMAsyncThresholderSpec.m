//
//  YMAsyncThresholderSpec.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/25.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

SpecBegin(YMAsyncThresholder)

it(@"should work", ^{
  YMAsyncThresholder* ex = [YMAsyncThresholder new];
  
  __block NSString* output;
  
  [ex queueBlock:^{
    output = @"A";
  }];
  
  expect(output).to.beNil();
  
  [ex unblock];
  
  expect(output).to.equal(@"A");
});

it(@"should work with after", ^{
  YMAsyncThresholder* ex = [YMAsyncThresholder new];
  
  __block NSString* output;
  
  [ex queueBlock:^{
    output = @"A";
  }];
  
  expect(output).to.beNil();
  
  [ex unblockAfter:1];
  
  expect(output).to.beNil();
  
  waitUntil(^(DoneCallback done) {
    dispatch_main_after(2, ^{
      expect(output).to.equal(@"A");
      done();
    });
  });
  
});

SpecEnd