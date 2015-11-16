//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "YMLoaderProxy.h"

#import "YMLoader.h"

@implementation YMLoaderProxy

- (YMLoader *__nonnull)loader {
  return [YMLoader sharedLoader];
}

- (void)build { }

+ (instancetype)proxy {
  return [self new];
}

+ (instancetype)new {
  return [[self alloc] init];
}

- (instancetype)init {
  _registry = [[NSMutableDictionary alloc] init];
  [self build];
  return self;
}

- (NSString *__nullable)loaderKeyForSelector:(SEL __nonnull)aSelector {
  return self.registry[NSStringFromSelector(aSelector)];
}

- (void)use:(NSString *__nonnull)loaderKey forSelector:(SEL __nonnull)aSelector {
  self.registry[NSStringFromSelector(aSelector)] = loaderKey;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  NSObject *obj = [[self loader] objectForKey:[self loaderKeyForSelector:invocation.selector]];
  [invocation invokeWithTarget:obj];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  NSObject *obj = [[self loader] objectForKey:[self loaderKeyForSelector:sel]];
  return [obj methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL __nonnull)aSelector {
  NSString *loaderKey = [self loaderKeyForSelector:aSelector];
  if (loaderKey == nil) {
    return NO;
  }
  return [[self loader] hasObjectForKey:loaderKey];
}

@end