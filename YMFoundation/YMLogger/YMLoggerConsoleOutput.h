//
// Created by Yanke Guo on 16/3/7.
//

#import <Foundation/Foundation.h>
#import "YMLoggerOutput.h"

@interface YMLoggerConsoleOutput: NSObject<YMLoggerOutput>

- (NSArray<NSString *> *__nonnull)allLogEntries;

@end
