//
// Created by Yanke Guo on 16/9/8.
//

#import "YRAdapter.h"

@implementation YRAdapter {
  YMAsyncQueue *__nullable _queue;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.statusPair = [YRStatusPair statusPair];
  }
  return self;
}

- (YMAsyncQueue *)queue {
  if (_queue == nil) {
    _queue = [[YMAsyncQueue alloc] init];
  }
  return _queue;
}

- (YRStatus *)status {
  return self.statusPair.status;
}

- (void)setStatus:(YRStatus *)status {
  [self appendStatus:status];
}

- (void)appendStatus:(YRStatus *__nonnull)status {
  self.statusPair = [self.statusPair statusPairWithNewStatus:status];
}

+ (NSSet<NSString *> *__nonnull)keyPathsForValuesAffectingStatus {
  return [NSSet setWithObject:@"statusPair"];
}

@end
