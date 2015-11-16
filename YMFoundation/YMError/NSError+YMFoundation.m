//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "NSError+YMFoundation.h"

#import "YMLocale.h"

const NSString *YMFoundationErrorLevelKey = @"YMFoundationErrorLevelKey";

@implementation NSError (YMFoundation)

- (YMErrorLevel)errorLevel {
  return [self.userInfo[YMFoundationErrorLevelKey] integerValue];
}

- (instancetype)initWithDomain:(NSString *__nonnull)domain code:(NSInteger)code errorLevel:(YMErrorLevel)errorLevel description:(NSString *__nonnull)description {
  return [self initWithDomain:domain code:code userInfo:@{
      YMFoundationErrorLevelKey : @(errorLevel),
      NSLocalizedDescriptionKey : description ?: @""
  }];
}

- (instancetype)errorWithErrorLevel:(YMErrorLevel)errorLevel {
  NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:self.userInfo];
  newUserInfo[YMFoundationErrorLevelKey] = @(errorLevel);
  return [(NSError *) [[self class] alloc] initWithDomain:self.domain code:self.code userInfo:newUserInfo];
}

- (NSString *__nonnull)readableDescription {
  NSString* ldesc = self.localizedDescription;
  if (ldesc.length) {
    return ldesc;
  }
  NSString* lfr   = self.localizedFailureReason;
  if (lfr.length) {
    return lfr;
  }
  return L(error.unknown_error);
}

@end