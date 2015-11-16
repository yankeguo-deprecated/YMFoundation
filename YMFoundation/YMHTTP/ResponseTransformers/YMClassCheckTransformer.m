//
//  YMClassCheckTransformer.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/10/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMClassCheckTransformer.h"
#import "NSError+YMHTTP.h"

@implementation YMClassCheckTransformer

+ (instancetype __nonnull)validatorWithClass:(Class)cls {
  return [[self alloc] initWithClass:cls];
}

- (instancetype)init {
  NSParameterAssert(NO);
  return nil;
}

- (instancetype __nonnull)initWithClass:(Class)cls {
  if (self = [super init]) {
    self.cls = cls;
  }
  return self;
}

- (id __nullable)transformResponse:(id __nullable)response error:(NSError *__nullable *__nonnull)error request:(YMHTTPRequest *__nonnull)request {
  if (![response isKindOfClass:self.cls]) {
    if (error) { *error = [NSError YMHTTPBadResponse]; }
    return nil;
  }
  return response;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ (Class = %@)", NSStringFromClass([self class]), self.cls];
}

@end
