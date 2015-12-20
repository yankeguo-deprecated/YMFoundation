//
//  YMMathUtils.m
//  YMFoundation
//
//  Created by Yanke Guo on 15/12/21.
//

#import "YMMathUtils.h"

void BitmaskEnumerateBits(NSUInteger value, void (^block)(NSUInteger bitValue)) {
  NSUInteger current = 1 << 0;
  while (current <= value) {
    if (current & value) {
      block(current);
    }
    current = current << 1;
  }
}

NSArray<NSNumber *> *NSArrayOfNumbersFromBitmask(NSUInteger value) {
  NSMutableArray *array = [[NSMutableArray alloc] init];
  BitmaskEnumerateBits(value, ^(NSUInteger bitValue) {
    [array addObject:@(bitValue)];
  });
  return array;
}
