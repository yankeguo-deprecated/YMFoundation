//
//  NSIndexPath+YMFoundation.m
//  YMFoundation
//
//  Created by Yanke Guo on 16/1/19.
//

#import "NSIndexPath+YMFoundation.h"

@implementation NSIndexPath (YMFoundation)

+ (NSIndexPath *__nonnull)emptyIndexPath {
  return [NSIndexPath indexPathWithIndexes:NULL length:0];
}

- (NSIndexPath *__nonnull)indexPathByCuttingToLength:(NSUInteger)length {
  NSIndexPath *result = self;
  while (result.length > length) {
    result = [result indexPathByRemovingLastIndex];
  }
  return result;
}

- (NSIndexPath *__nonnull)indexPathByFilingToLength:(NSUInteger)length withIndex:(NSUInteger)index {
  NSIndexPath *result = self;
  while (result.length < length) {
    result = [result indexPathByAddingIndex:index];
  }
  return result;
}

@end
