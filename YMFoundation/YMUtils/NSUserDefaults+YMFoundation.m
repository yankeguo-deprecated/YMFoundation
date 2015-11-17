//
// Created by Yanke Guo on 15/11/17.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "NSUserDefaults+YMFoundation.h"


@implementation NSUserDefaults (YMFoundation)

- (void)setOrRemoveObject:(id __nullable)object forKey:(NSString *__nonnull)key {
  if (object == nil) {
    [self removeObjectForKey:key];
  } else {
    [self setObject:object forKey:key];
  }
}

@end