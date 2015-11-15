//
//  YMLogger.h
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "UALogger.h"

#pragma mark - Log shortcuts

#ifdef YM_VERBOSE_LOG

#define DLog(format, ...) UASLogBasic(UALoggerSeverityDebug, format, ##__VA_ARGS__)
#define ILog(format, ...) UASLogBasic(UALoggerSeverityInfo, format, ##__VA_ARGS__)

#else

#define DLog(format, ...)
#define ILog(format, ...)

#endif

#define WLog(format, ...) UASLogBasic(UALoggerSeverityWarn, format, ##__VA_ARGS__)
#define ELog(format, ...) UASLogBasic(UALoggerSeverityError, format, ##__VA_ARGS__)
#define FLog(format, ...) UASLogBasic(UALoggerSeverityFatal, format, ##__VA_ARGS__)

#pragma mark - Init

inline void YMLoggerInit() {
  [UALogger setShouldLogInProduction:YES];
  [UALogger setMinimumSeverity:UALoggerSeverityDebug];
}