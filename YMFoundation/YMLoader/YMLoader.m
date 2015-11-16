//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "YMLoader.h"

@interface YMLoader ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, YMLoaderObjectFactory> *registry;

@end

@implementation YMLoader

+ (YMLoader *)sharedLoader {
  static YMLoader *_instance = nil;

  @synchronized (self) {
    if (_instance == nil) {
      _instance = [[self alloc] init];
    }
  }

  return _instance;
}

- (id)init {
  if (self = [super init]) {
    self.registry = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)registerObject:(id)object forKey:(NSString *__nonnull)key {
  [self registerFactory:^id {
    return object;
  }              forKey:key];
}

- (void)registerFactory:(YMLoaderObjectFactory __nonnull)objectFactory forKey:(NSString *__nonnull)key {
  self.registry[key] = objectFactory;
}

- (id __nullable)objectForKey:(NSString *__nonnull)key {
  YMLoaderObjectFactory factory = self.registry[key];
  if (factory) {
    return factory();
  }
  return nil;
}

- (id __nullable)objectForKeyedSubscript:(NSString *__nonnull)key {
  return [self objectForKey:key];
}

- (BOOL)hasObjectForKey:(NSString *__nonnull)key {
  return [self.registry objectForKey:key] != nil;
}

@end