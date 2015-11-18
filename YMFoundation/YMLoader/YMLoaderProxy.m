//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "YMLoaderProxy.h"

#import <objc/runtime.h>

#import "YMLogger.h"
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

- (id)targetForSelector:(SEL)aSelector {
  NSString *loaderKey = [self loaderKeyForSelector:aSelector];
  if (loaderKey == nil) return nil;
  return [[self loader] objectForKey:loaderKey];
}

- (void)use:(NSString *__nonnull)loaderKey forSelector:(SEL __nonnull)aSelector {
  self.registry[NSStringFromSelector(aSelector)] = loaderKey;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  NSObject *obj = [self targetForSelector:invocation.selector];
  [invocation invokeWithTarget:obj];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  NSObject *obj = [self targetForSelector:sel];
  return [obj methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL __nonnull)aSelector {
  return [[self targetForSelector:aSelector] respondsToSelector:aSelector];
}

- (BOOL)validate {
  __block BOOL success = YES;

  //  Validate registry
  [self.registry enumerateKeysAndObjectsUsingBlock:^(NSString *selectorName, NSString *loaderKey, BOOL *stop) {
    SEL sel = NSSelectorFromString(selectorName);
    //  Test
    BOOL match = [self respondsToSelector:sel];
    if (match) {
      DLog(@"YMLoaderProxy PASS %@ - %@", self, selectorName);
    } else {
      NSAssert(NO, @"%@ cannot responds to selector %@", self, selectorName);
    }
    //  Update success flag
    success &= match;
    //  Stop if not match
    if (!match) *stop = YES;
  }];

  //  Validate protocol
  unsigned int allProtocolsCount = 0;
  Protocol *const *allProtocols = class_copyProtocolList([self class], &allProtocolsCount);
  for (unsigned int i = 0; i < allProtocolsCount; i++) {
    //  Break if already failed
    if (!success) break;

    //  Get the protocol
    Protocol *const aProtocol = allProtocols[i];

    //  Skip NSObject Protocol
    if ([NSStringFromProtocol(aProtocol) isEqualToString:@"NSObject"]) {
      continue;
    }

    //  Get all methods
    unsigned int allMethodsCount = 0;
    struct objc_method_description
        *allMethods = protocol_copyMethodDescriptionList(aProtocol, NO, NO, &allMethodsCount);

    //  Walk through all methods
    for (unsigned int j = 0; j < allMethodsCount; j++) {
      //  Break if already failed
      if (!success) break;

      //  Validate method
      struct objc_method_description method = allMethods[j];
      BOOL match = [self respondsToSelector:method.name];

      if (match) {
        DLog(@"YMLoaderProxy PASS %@ - %@", self, NSStringFromSelector(method.name));
      } else {
        NSAssert(NO,
                 @"%@ can not responds to %@ in protocol %@",
                 self,
                 NSStringFromSelector(method.name),
                 NSStringFromProtocol(aProtocol));
      }

      //  Record success
      success &= match;
    }

    //  Clean up
    free(allMethods);
  }

  //  Clean up
  free((void *) allProtocols);

  return success;
}

- (NSString *)debugDescription {
  NSMutableString *mutableString = [[NSMutableString alloc] initWithString:NSStringFromClass([self class])];
  [self.registry enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    [mutableString appendFormat:@"\n %@ -> %@", key, obj];
  }];
  return [mutableString copy];
}

@end