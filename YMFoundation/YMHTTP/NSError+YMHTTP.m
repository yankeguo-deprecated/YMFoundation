//
// Created by Yanke Guo on 15/11/17.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "NSError+YMHTTP.h"

#import "NSError+YMFoundation.h"
#import "YMLocale.h"

const NSString *YMHTTPErrorDomain = @"com.juxian.YMFoundation.YMHTTP.error";

@implementation NSError (YMHTTP)

- (BOOL)isYMHTTPError {
  return [YMHTTPErrorDomain isEqualToString:self.domain];
}

+ (instancetype)YMHTTPBadResponse {
  return [(NSError *) [[self class] alloc] initWithDomain:[YMHTTPErrorDomain copy]
                                                     code:YMHTTPErrorCodeBadResponse
                                               errorLevel:YMErrorLevelHigh
                                              description:L(error.http_bad_response)];
}

+ (instancetype)YMHTTPBadNetwork {
  return [(NSError *) [[self class] alloc] initWithDomain:[YMHTTPErrorDomain copy]
                                                     code:YMHTTPErrorCodeBadNetwork
                                               errorLevel:YMErrorLevelHigh
                                              description:L(error.http_bad_network)];
}

+ (instancetype)YMHTTPCancelled {
  return [(NSError *) [[self class] alloc] initWithDomain:[YMHTTPErrorDomain copy]
                                                     code:YMHTTPErrorCodeCancelled
                                                    fatal:NO
                                               errorLevel:YMErrorLevelIgnored
                                              description:L(error.http_cancelled)];
}

@end