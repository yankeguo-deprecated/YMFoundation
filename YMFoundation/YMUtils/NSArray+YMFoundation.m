//
//  NSArray+YMFoundation.m
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import "NSArray+YMFoundation.h"

@implementation NSArray (YMFoundation)

- (id)objectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
  __block id found = nil;
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if (predicate(obj, idx, stop)) {
      found = obj;
      *stop = YES;
    }
  }];
  return found;
}

- (id)objectOrNilAtIndex:(NSUInteger)index {
  if (index >= self.count) return nil;
  return self[index];
}

@end
