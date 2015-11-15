//
//  YMAsyncCallbackStoreSpec.m
//  YMFoundationExample
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "YMFoundationTestsHelper.h"

typedef void(^YMTestCallback) (NSString* __nullable result);

SpecBegin(YMAsyncCallbackStore)

__block YMAsyncCallbackStore<YMTestCallback>* _callbackStore;

describe(@"basic usage", ^{
  
  it(@"should work", ^{
    __block NSString* value = @"";
    
    YMTestCallback testCallback = ^(NSString* result) {
      value = [result copy];
    };
    
    _callbackStore = [YMAsyncCallbackStore storeWithExpireHandler:nil expires:0];
    [_callbackStore addCallback:testCallback];
    
    [_callbackStore invokeAllCallbacks:^(YMTestCallback  _Nonnull callback) {
      callback(@"1");
    }];
    
    dispatch_async_main(^{
      XCTAssertEqualObjects(value, @"1");
    });
  });
  
  it(@"should work with multiple", ^{
    __block NSString* value = @"";
    
    YMTestCallback testCallback = ^(NSString* result) {
      value = [result copy];
    };
    
    YMTestCallback testCallback2 = ^(NSString* result) {
      value = @"3";
    };
    
    _callbackStore = [YMAsyncCallbackStore storeWithExpireHandler:nil expires:0];
    [_callbackStore addCallback:testCallback];
    [_callbackStore addCallback:testCallback2];
    
    [_callbackStore invokeAllCallbacks:^(YMTestCallback  _Nonnull callback) {
      callback(@"1");
    }];
    
    dispatch_async_main(^{
      XCTAssertEqualObjects(value, @"3");
    });
  });
  
  it(@"should work with remove", ^{
    __block NSString* value = @"";
    
    YMTestCallback testCallback = ^(NSString* result) {
      value = [result copy];
    };
    
    YMTestCallback testCallback2 = ^(NSString* result) {
      value = @"3";
    };
    
    _callbackStore = [YMAsyncCallbackStore storeWithExpireHandler:nil expires:0];
    [_callbackStore addCallback:testCallback];
    NSInteger callbackId2 = [_callbackStore addCallback:testCallback2];
    
    [_callbackStore removeCallbackWithId:callbackId2];
    
    [_callbackStore invokeAllCallbacks:^(YMTestCallback  _Nonnull callback) {
      callback(@"1");
    }];
    
    dispatch_async_main(^{
      XCTAssertEqualObjects(value, @"1");
    });
  });
  
});

SpecEnd