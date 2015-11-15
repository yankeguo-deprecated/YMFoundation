//
//  YMLogger.m
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "YMLogger.h"

void YMLoggerEnableDebug() {
  [UALogger setMinimumSeverity:UALoggerSeverityDebug];
}
