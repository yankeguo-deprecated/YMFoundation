//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "NSDictionary+YMFoundation.h"


@implementation NSDictionary (YMFoundation)

+ (void)flattenDictionary:(NSDictionary *)dictionary intoContainerDictionary:(NSMutableDictionary<NSString *, NSString *> *)container parent:(NSString *)parent {
  [dictionary enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
    NSString *fullKey =
        parent.length == 0 ? [NSString stringWithFormat:@"%@", key] : [NSString stringWithFormat:@"%@.%@", parent, key];
    if ([obj isKindOfClass:[NSDictionary class]]) {
      [NSDictionary flattenDictionary:obj intoContainerDictionary:container parent:fullKey];
    } else {
      container[fullKey] = [NSString stringWithFormat:@"%@", obj];
    }
  }];
}

- (NSDictionary<NSString *, NSString *> *__nonnull)flattenedDictionary {
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [NSDictionary flattenDictionary:self intoContainerDictionary:dict parent:@""];
  return dict;
}

@end