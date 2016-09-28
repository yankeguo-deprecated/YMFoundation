//
//  YMModel.m
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import "YMModel.h"
#import "YMUtils.h"

NSString *YMModelNilId = @"__NIL_ID__";

@implementation YMModel

- (BOOL)isNilId {
  return NSStringEquals(YMModelNilId, self.id);
}

- (void)didInit {
  self.id = [YMModelNilId copy];
  self.adapter = [[YRAdapter alloc] init];
}

+ (void)buildDescriptor:(YMJSONDescriptor *)descriptor {
  [super buildDescriptor:descriptor];
  [descriptor addRequired:@"id"];
}

#pragma mark - Resource

+ (NSSet<NSString *> *__nonnull)keyPathsForValuesAffectingStatus {
  return [NSSet setWithObject:@"adapter.statusPair"];
}

+ (NSSet<NSString *> *__nonnull)keyPathsForValuesAffectingStatusPair {
  return [NSSet setWithObject:@"adapter.statusPair"];
}

- (YMAsyncQueue *)queue {
  return self.adapter.queue;
}

- (YRStatus *)status {
  return self.adapter.status;
}

- (void)setStatus:(YRStatus *)status {
  self.adapter.status = status;
}

- (YRStatusPair *)statusPair {
  return self.adapter.statusPair;
}

- (void)setStatusPair:(YRStatusPair *)statusPair {
  self.adapter.statusPair = statusPair;
}

- (void)appendStatus:(YRStatus *)status {
  [self.adapter appendStatus:status];
}

@end
