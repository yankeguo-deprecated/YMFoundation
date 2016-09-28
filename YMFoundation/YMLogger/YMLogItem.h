//
// Created by Yanke Guo on 16/8/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YMLoggerSeverity) {
  YMLoggerSeverityDebug,            // Lowest log level
  YMLoggerSeverityInfo,
  YMLoggerSeverityWarn,
  YMLoggerSeverityError,
  YMLoggerSeverityFatal             // Highest log level
};

extern NSString *__nonnull NSStringFromYMLoggerSeverity(YMLoggerSeverity severity);

@interface YMLogItem : NSObject

@property(nonatomic, assign) YMLoggerSeverity serverity;

@property(nonatomic, strong) NSString *__nonnull bundleName;

@property(nonatomic, strong) NSString *__nonnull bundleVersion;

@property(nonatomic, strong) NSDate *__nonnull time;

@property(nonatomic, strong) NSString *__nonnull lineInfo;

@property(nonatomic, strong) NSString *__nonnull content;

@end
