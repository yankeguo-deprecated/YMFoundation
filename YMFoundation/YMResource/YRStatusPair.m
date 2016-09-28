//
//  YMResourceStatus.m
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import "YRStatusPair.h"

@implementation YRStatusPair

- (instancetype)statusPairWithNewStatus:(YRStatus *__nonnull)newStatus {
  if (newStatus == nil) newStatus = [YRStatus inited];
  YRStatusPair *pair = [YRStatusPair new];
  pair->_lastStatus = [self.status copy];
  pair->_status = [newStatus copy];
  return pair;
}

- (instancetype)init {
  return [self initWithStatus:[YRStatus inited] lastStatus:[YRStatus inited]];
}

+ (BOOL)supportsSecureCoding {
  return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.status forKey:@"status"];
  [coder encodeObject:self.lastStatus forKey:@"last_status"];
}

+ (instancetype)statusPair {
  return (YRStatusPair *) [[self.class alloc] init];
}

- (instancetype)initWithStatus:(YRStatus *)status lastStatus:(YRStatus *)lastStatus {
  self = [super init];
  if (self) {
    _status = [status copy];
    _lastStatus = [lastStatus copy];
    if (_status == nil) _status = [YRStatus inited];
    if (_lastStatus == nil) _lastStatus = [YRStatus inited];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super init];
  if (self) {
    _status = [coder decodeObjectOfClass:[YRStatus class] forKey:@"status"];
    _lastStatus = [coder decodeObjectOfClass:[YRStatus class] forKey:@"last_status"];
    if (_status == nil) _status = [YRStatus inited];
    if (_lastStatus == nil) _lastStatus = [YRStatus inited];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  YRStatusPair *pair = [YRStatusPair new];
  pair->_status = [self.status copy];
  pair->_lastStatus = [self.lastStatus copy];
  return pair;
}

- (BOOL)isEqual:(YRStatusPair *)other {
  if (other == self)
    return YES;
  if (!other || ![[other class] isEqual:[self class]])
    return NO;
  return [other.status isEqual:self.status] && [other.lastStatus isEqual:self.lastStatus];
}

@end
