//
// Created by Yanke Guo on 16/3/7.
//

#import <Foundation/Foundation.h>
#import "YMLogItem.h"

@class YMLogger;

@protocol YMLoggerOutput<NSObject>

/**
 * Output a line of log
 */
- (void)logger:(YMLogger *__nonnull)logger didOutputItem:(YMLogItem *__nonnull)item;

 @optional
- (void)didAddToLogger:(YMLogger *__nonnull)logger;

- (void)didRemoveFromLogger:(YMLogger *__nonnull)logger;

@end
