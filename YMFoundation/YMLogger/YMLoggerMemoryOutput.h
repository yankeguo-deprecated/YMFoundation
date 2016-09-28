//
// Created by Yanke Guo on 16/8/29.
//

#import <Foundation/Foundation.h>

#import "YMLoggerOutput.h"

@interface YMLoggerMemoryOutput : NSObject<YMLoggerOutput>

@property(nonatomic, readonly) NSArray<YMLogItem *> *__nonnull lines;

@property(nonatomic, assign) NSUInteger maxLines;

@end
