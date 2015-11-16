//
//  YMKeyPathTransformer.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMKeyPathTransformer.h"

@implementation YMKeyPathTransformer

+ (instancetype __nonnull)transformerWithKeyPath:(NSString *__nonnull)keyPath {
  return [[self alloc] initWithKeyPath:keyPath];
}

- (id __nonnull)initWithKeyPath:(NSString *__nonnull)keyPath {
  if (self = [super init]) {
    _keyPath = [keyPath copy];
  }
  return self;
}

- (id __nullable)transformResponse:(id __nullable)response error:(NSError *__nullable *__nonnull)error request:(YMHTTPRequest *__nonnull)request {
  return [response valueForKeyPath:_keyPath];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ (keyPath = %@)", NSStringFromClass([self class]), self.keyPath];
}

@end
