//
// Created by Yanke Guo on 16/5/11.
//

#import "NSDecimalNumber+YMFoundation.h"


@implementation NSDecimalNumber (YMFoundation)

- (instancetype)sanitize {
  if ([self isEqualToNumber:[NSDecimalNumber notANumber]]) {
    return [NSDecimalNumber zero];
  }
  return self;
}

@end