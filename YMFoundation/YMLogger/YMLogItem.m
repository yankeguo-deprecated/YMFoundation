//
// Created by Yanke Guo on 16/8/29.
//

#import "YMLogItem.h"

NSString *__nonnull NSStringFromYMLoggerSeverity(YMLoggerSeverity severity) {
  switch (severity) {
    case YMLoggerSeverityDebug:return @"D";
    case YMLoggerSeverityInfo:return @"I";
    case YMLoggerSeverityWarn:return @"W";
    case YMLoggerSeverityError:return @"E";
    case YMLoggerSeverityFatal:return @"F";
    default:return @"?";
  }
}

@implementation YMLogItem

@end