//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Error presentation level
 */
typedef NS_ENUM(NSInteger, YMErrorLevel) {
  /**
   * This error can be ignored, maybe some kind of cancelled
   */
      YMErrorLevelIgnored = -2,

  /**
   * This error is just a warning, things gonna continue
   */
      YMErrorLevelLow = -1,

  /**
   * This error is a failure, procedure should stop (default)
   */
      YMErrorLevelHigh = 0,
};

extern const NSString *__nonnull YMFoundationErrorLevelKey;

/*
 * Default to FATAL, thus 0 for fatal, 1 for non-fatal
 */
extern const NSString *__nonnull YMFoundationErrorFatalKey;

@interface NSError (YMFoundation)

@property(nonatomic, readonly) YMErrorLevel errorLevel;

@property(nonatomic, readonly, getter=isFatal) BOOL fatal;

/**
 * Create a new error object with errorLevel set
 */
- (instancetype __nonnull)initWithDomain:(NSString *__nonnull)domain
                                    code:(NSInteger)code
                                   fatal:(BOOL)fatal
                              errorLevel:(YMErrorLevel)errorLevel
                             description:(NSString *__nonnull)description;
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
 * Create a copy of this error, setting isFatal
 */
- (instancetype __nonnull)errorWithFatal:(BOOL)fatal;

/**
 * Readable description
 *
 * i18n(error.unknown_error)
 *
 * Try localizedDescription, localizedFailureReason, or L(error.unknown_error)
 */
- (NSString *__nonnull)readableDescription;

@end