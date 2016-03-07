//
//  YMLogger.h
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "YMLoggerOutput.h"
#import "YMLoggerConsoleOutput.h"

#pragma mark - Useful Macros

#define __LINE_INFO__         ([NSString stringWithFormat:@"(%@:%@)", [@(__FILE__) lastPathComponent], @(__LINE__)])
#define __LINE_DETAIL_INFO__  ([NSString stringWithFormat:@"(%@:%@) %@", [@(__FILE__) lastPathComponent], @(__LINE__), @(__PRETTY_FUNCTION__)])

#define YMSLog(s, f, ...) ([[YMLogger sharedInstance] logWithSeverity:s lineInfo:__LINE_INFO__ content:[NSString stringWithFormat:(f), ##__VA_ARGS__]])

#define DLog(format, ...) YMSLog(YMLoggerSeverityDebug, format, ##__VA_ARGS__)
#define ILog(format, ...) YMSLog(YMLoggerSeverityInfo, format, ##__VA_ARGS__)
#define WLog(format, ...) YMSLog(YMLoggerSeverityWarn, format, ##__VA_ARGS__)
#define ELog(format, ...) YMSLog(YMLoggerSeverityError, format, ##__VA_ARGS__)
#define FLog(format, ...) YMSLog(YMLoggerSeverityFatal, format, ##__VA_ARGS__)

#pragma mark - YMLogger

typedef NS_ENUM(NSInteger, YMLoggerSeverity) {
  YMLoggerSeverityDebug,            // Lowest log level
  YMLoggerSeverityInfo,
  YMLoggerSeverityWarn,
  YMLoggerSeverityError,
  YMLoggerSeverityFatal             // Highest log level
};

extern NSString *__nonnull NSStringFromYMLoggerSeverity(YMLoggerSeverity severity);

@interface YMLogger: NSObject

/* Detect DEBUG pre-process macro */
@property(nonatomic, readonly, getter=isDebug) BOOL debug;

/* Detect DEBUG pre-process macro */
@property(nonatomic, readonly, getter=isRelease) BOOL release;

/* Severity for current DEBUG/RELEASE config */
@property(nonatomic, assign) YMLoggerSeverity minimumSeverity;

@property(nonatomic, readonly) NSString *__nonnull bundleName;

@property(nonatomic, readonly) NSString *__nonnull bundleVersion;

/* Outputs */
@property(nonatomic, readonly) NSArray<id<YMLoggerOutput>> *__nonnull outputs;

/* Console Output, default added to self.outputs */
@property(nonatomic, readonly) YMLoggerConsoleOutput *__nonnull consoleOutput;

/* Shared instance */
+ (instancetype __nonnull)sharedInstance;

/* Add a output */
- (void)addOutput:(id<YMLoggerOutput> __nonnull)output;

- (void)removeOutputAtIndex:(NSUInteger)index;

/* setMinimumSeverity only in DEBUG */
- (void)setDebugMinimumSeverity:(YMLoggerSeverity)minimumSeverity;

/* setMinimumSeverity only in RELEASE */
- (void)setReleaseMinimumSeverity:(YMLoggerSeverity)minimumSeverity;

/* Do log */
- (void)logWithSeverity:(YMLoggerSeverity)severity lineInfo:(NSString *__nonnull)lineInfo content:(NSString *__nonnull)content;

@end
