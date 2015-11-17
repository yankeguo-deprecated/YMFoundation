//
// Created by Yanke Guo on 15/11/17.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "NSMutableDictionary+YMFoundation.h"

#import <objc/runtime.h>

static const void *YMFoundationNSMutableDictionaryValueFactoryKey = &YMFoundationNSMutableDictionaryValueFactoryKey;

@implementation NSMutableDictionary (YMFoundation)

- (id (^)())valueFactory {
  return objc_getAssociatedObject(self, YMFoundationNSMutableDictionaryValueFactoryKey);
}

- (void)setValueFactory:(id (^)())valueFactory {
  NSParameterAssert(valueFactory);
  objc_setAssociatedObject(self,
                           YMFoundationNSMutableDictionaryValueFactoryKey,
                           valueFactory,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)objectDefiniteForKey:(id)key {
  NSParameterAssert(self.valueFactory);
  id value = [self objectForKey:key];
  if (value == nil) {
    value = self.valueFactory();
    [self setObject:value forKey:key];
  }
  return value;
}

@end