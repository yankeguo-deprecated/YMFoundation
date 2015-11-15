//
//  YMLogger.h
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "UALogger.h"

#pragma mark - Useful Macros

#define __LINE_INFO__ ([NSString stringWithFormat:@"%@(%@) %@", [@(__FILE__) lastPathComponent], @(__LINE__), @(__PRETTY_FUNCTION__)])

#pragma mark - Log Shortcuts

#define DLog(format, ...) UASLogBasic(UALoggerSeverityDebug, format, ##__VA_ARGS__)
#define ILog(format, ...) UASLogBasic(UALoggerSeverityInfo, format, ##__VA_ARGS__)
#define WLog(format, ...) UASLogBasic(UALoggerSeverityWarn, format, ##__VA_ARGS__)
#define ELog(format, ...) UASLogBasic(UALoggerSeverityError, format, ##__VA_ARGS__)
#define FLog(format, ...) UASLogBasic(UALoggerSeverityFatal, format, ##__VA_ARGS__)

#pragma mark - YMLogger Configs

extern void YMLoggerEnableDebug();
