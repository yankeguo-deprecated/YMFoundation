//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YMErrorLevel) {
  /**
   * This error can be ignored, maybe some kind of cancelled
   */
      YMErrorLevelIgnored = -2,

  /**
   * This error is just a warning, things gonna continue
   */
      YMErrorLevelNonBlocking = -1,

  /**
   * This error is a failure, procedure should stop (default)
   */
      YMErrorLevelBlocking = 0,
};

extern const NSString *__nonnull YMFoundationErrorLevelKey;

@interface NSError (YMFoundation)

@property(nonatomic, readonly) YMErrorLevel errorLevel;

/**
 * Create a new error object with errorLevel set
 */
- (instancetype __nonnull)initWithDomain:(NSString *__nonnull)domain
                                    code:(NSInteger)code
                              errorLevel:(YMErrorLevel)errorLevel
                             description:(NSString *__nonnull)description;

/**
 * Create a copy of this error, setting errorLevel
 */
- (instancetype __nonnull)errorWithErrorLevel:(YMErrorLevel)errorLevel;

/**
 * Readable description
 *
 * Try localizedDescription, localizedFailureReason, or L(error.unknown_error)
 */
- (NSString* __nonnull)readableDescription;

@end