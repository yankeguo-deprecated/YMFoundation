//
//  YMCallbackStore.m
//  YMXian
//
//  Created by Yanke Guo on 15/6/4.
//  Copyright (c) 2015年 Yanke Guo. All rights reserved.
//

#import "YMCallbackStore.h"

#import "YMAsyncDispatchUtils.h"

@interface YMCallbackStore<ObjectType> ()

@property(nonatomic, assign) NSTimeInterval expires;
@property(nonatomic, strong) void(^__nullable expireHandler)(ObjectType __nonnull callback);

@property(nonatomic, strong) NSMutableDictionary *callbacks;
@property(atomic, assign) NSInteger callbackId;

@end

@implementation YMCallbackStore

+ (id __nonnull)storeWithExpireHandler:(void (^ __nullable)(id __nonnull callback))expireHandler expires:(NSTimeInterval)expires {
  return [[self alloc] initWithExpireHandler:expireHandler expires:expires];
}

- (id __nonnull)initWithExpireHandler:(void (^ __nullable)(id __nonnull callback))expireHandler expires:(NSTimeInterval)expires {
  NSParameterAssert(expireHandler || expires == 0);
  if (self = [super init]) {
    self.callbackId = 0;
    self.expireHandler = [expireHandler copy];
    self.expires = expires;
    self.callbacks = [NSMutableDictionary new];
  }
  return self;
}

- (NSInteger)addCallback:(id __nonnull)callback {
  NSInteger currentCallbackId = [self bumpCallbackId];

  self.callbacks[@(currentCallbackId)] = [callback copy];

  if (self.expires != 0) {
    dispatch_main_after(self.expires, ^{
      id callback = [self.callbacks objectForKey:@(currentCallbackId)];
      if (callback) {
        [self.callbacks removeObjectForKey:@(currentCallbackId)];
        self.expireHandler(callback);
      }
    });
  }

  return currentCallbackId;
}

- (void)invokeAllCallbacks:(void (^ __nonnull)(id __nonnull callback))handler {
  dispatch_async_main(^{
    [self.callbacks enumerateKeysAndObjectsUsingBlock:^(NSNumber *callbackId, id callback, BOOL *stop) {
      handler(callback);
    }];
    [self.callbacks removeAllObjects];
  });
}

- (NSInteger)bumpCallbackId {
  return self.callbackId++;
}

- (void)removeCallbackWithId:(NSInteger)callbackID {
  [self.callbacks removeObjectForKey:@(callbackID)];
}

@end
