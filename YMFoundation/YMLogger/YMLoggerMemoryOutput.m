//
// Created by Yanke Guo on 16/8/29.
//

#import "YMLoggerMemoryOutput.h"

@implementation YMLoggerMemoryOutput {
  NSMutableArray *_lines;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _lines = [[NSMutableArray alloc] init];
    self.maxLines = 1000;
  }
  return self;
}

- (void)logger:(YMLogger *__nonnull)logger didOutputItem:(YMLogItem *__nonnull)item {
  if (_lines.count > self.maxLines) {
    [_lines removeObjectAtIndex:0];
  }
  [_lines addObject:item];
}

@end
