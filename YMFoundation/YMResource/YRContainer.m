//
// Created by Yanke Guo on 16/8/16.
//

#import "YRContainer.h"
#import "YMAsyncQueue.h"

@implementation YRContainer {
  YMAsyncQueue *_queue;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.statusPair = [YRStatusPair statusPair];
  }
  return self;
}

- (YMAsyncQueue *)queue {
  if (_queue == nil) _queue = [YMAsyncQueue queue];
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

+ (instancetype)container {
  return [[[self class] alloc] init];
}

#pragma mark - KVO

+ (NSSet<NSString *> *__nonnull)keyPathsForValuesAffectingStatus {
  return [NSSet setWithObject:@"statusPair"];
}

@end

@implementation YRObjectContainer

@dynamic value;

@end

@implementation YRArrayContainer

@dynamic value;

- (NSArray *__nonnull)valueDefinite {
  return self.value ?: @[];
}

- (void)appendArray:(NSArray *__nullable)array {
  if (array == nil) return;
  self.value = [self.value arrayByAddingObjectsFromArray:array];
}

@end