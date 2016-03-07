//
//  YMLogger.m
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import "YMLogger.h"
#import "NSDate+ISO8601.h"

NSString *__nonnull NSStringFromYMLoggerSeverity(YMLoggerSeverity severity) {
  switch (severity) {
    case YMLoggerSeverityDebug:
      return @"D";
    case YMLoggerSeverityInfo:
      return @"I";
    case YMLoggerSeverityWarn:
      return @"W";
    case YMLoggerSeverityError:
      return @"E";
    case YMLoggerSeverityFatal:
      return @"F";
    default:
      return @"?";
  }
}

@interface YMLogger () {
  NSMutableArray<id<YMLoggerOutput>> *__nonnull _outputs;
}

@end

@implementation YMLogger

- (BOOL)isDebug {
#ifdef DEBUG
  return YES;
#else
  return NO;
#endif
}

- (BOOL)isRelease {
  return !self.isDebug;
}

+ (instancetype)sharedInstance {
  static YMLogger *_shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _shared = [YMLogger new];
  });
  return _shared;
}

- (void)addOutput:(id<YMLoggerOutput> __nonnull)output {
  if ([output respondsToSelector:@selector(didAddToLogger:)]) {
    [output didAddToLogger:self];
  }
  [_outputs addObject:output];
}

- (void)removeOutputAtIndex:(NSUInteger)index {
  id<YMLoggerOutput> output = self.outputs[index];
  [_outputs removeObjectAtIndex:index];
  if ([output respondsToSelector:@selector(didRemoveFromLogger:)]) {
    [output didRemoveFromLogger:self];
  }
}

- (instancetype)init {
  self = [super init];
  if (self) {
    //  Create outputs
    _outputs = [[NSMutableArray alloc] init];
    _consoleOutput = [YMLoggerConsoleOutput new];
    [self addOutput:self.consoleOutput];
    _bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    _bundleVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    //  Set default severity
    if (self.isDebug) {
      self.minimumSeverity = YMLoggerSeverityDebug;
    } else {
      self.minimumSeverity = YMLoggerSeverityWarn;
    }
  }
  return self;
}

- (void)setDebugMinimumSeverity:(YMLoggerSeverity)minimumSeverity {
  if (self.isDebug) {
    self.minimumSeverity = minimumSeverity;
  }
}

- (void)setReleaseMinimumSeverity:(YMLoggerSeverity)minimumSeverity {
  if (self.isRelease) {
    self.minimumSeverity = minimumSeverity;
  }
}

- (void)logWithSeverity:(YMLoggerSeverity)severity lineInfo:(NSString *__nonnull)lineInfo content:(NSString *__nonnull)content {
  if (severity < self.minimumSeverity) { return; }
  NSString *line = [NSString stringWithFormat:@"%@, %@/%@, %@, %@: %@", NSStringFromYMLoggerSeverity(severity), self.bundleName, self.bundleVersion, [[NSDate date] ISO8601String], lineInfo, content];
  [self.outputs enumerateObjectsUsingBlock:^(id<YMLoggerOutput> output, NSUInteger idx, BOOL *stop) {
    [output logger:self didOutputLine:line];
  }];
}

@end
