//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "NSError+YMFoundation.h"

#import "YMLocale.h"

const NSString *YMFoundationErrorLevelKey = @"YMFoundationErrorLevelKey";

const NSString *YMFoundationErrorFatalKey = @"YMFoundationErrorFatalKey";

@implementation NSError (YMFoundation)

- (YMErrorLevel)errorLevel {
  return [self.userInfo[YMFoundationErrorLevelKey] integerValue];
}

- (BOOL)isFatal {
  return [self.userInfo[YMFoundationErrorFatalKey] integerValue] == 0;
}

- (instancetype)initWithDomain:(NSString *__nonnull)domain
                          code:(NSInteger)code
                         fatal:(BOOL)fatal
                    errorLevel:(YMErrorLevel)errorLevel
                   description:(NSString *__nonnull)description {
  return [self initWithDomain:domain code:code userInfo:@{
      YMFoundationErrorLevelKey : @(errorLevel),
      NSLocalizedDescriptionKey : description ?: @"",
      YMFoundationErrorFatalKey : fatal ? @0 : @1
  }];
}

- (instancetype)initWithDomain:(NSString *__nonnull)domain
                          code:(NSInteger)code
                    errorLevel:(YMErrorLevel)errorLevel
                   description:(NSString *__nonnull)description {
  return [self initWithDomain:domain code:code fatal:YES errorLevel:errorLevel description:description];
}

- (instancetype)errorWithErrorLevel:(YMErrorLevel)errorLevel {
  NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:self.userInfo];
  newUserInfo[YMFoundationErrorLevelKey] = @(errorLevel);
  return [(NSError *) [[self class] alloc] initWithDomain:self.domain code:self.code userInfo:newUserInfo];
}

- (instancetype)errorWithFatal:(BOOL)fatal {
  NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:self.userInfo];
  newUserInfo[YMFoundationErrorFatalKey] = fatal ? @0 : @1;
  return [(NSError *) [[self class] alloc] initWithDomain:self.domain code:self.code userInfo:newUserInfo];
}

- (NSString *__nonnull)readableDescription {
  NSString *ldesc = self.localizedDescription;
  if (ldesc.length) {
    return ldesc;
  }
  NSString *lfr = self.localizedFailureReason;
  if (lfr.length) {
    return lfr;
  }
  return L(error.unknown_error);
}

@end