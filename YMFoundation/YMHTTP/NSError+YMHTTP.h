//
// Created by Yanke Guo on 15/11/17.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *__nonnull YMHTTPErrorDomain;

typedef NS_ENUM(NSInteger, YMHTTPErrorCode) {
  /**
   * Cancelled, locale_key = error.http_cancelled
   */
      YMHTTPErrorCodeCancelled,
  /**
   * Bad Response, locale_key = error.http_bad_response
   */
      YMHTTPErrorCodeBadResponse,
  /**
   * Bad Network, locale_key = error.http_bad_network
   */
      YMHTTPErrorCodeBadNetwork,
};

@interface NSError (YMHTTP)

- (BOOL)isYMHTTPError;

+ (instancetype __nonnull)YMHTTPBadResponse;

+ (instancetype __nonnull)YMHTTPBadNetwork;

+ (instancetype __nonnull)YMHTTPCancelled;

@end