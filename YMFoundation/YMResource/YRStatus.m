//
// Created by Yanke Guo on 16/8/4.
//

#import "YRStatus.h"
#import "YMResource.h"
#import "YMUtils.h"

@implementation YRStatus

+ (instancetype)status {
  return [self statusWithType:YRStatusTypeInited];
}

+ (instancetype)statusWithType:(YRStatusType)type {
  return [(YRStatus *) [[self class] alloc] initWithType:type];
}

+ (instancetype)inited {
  return [self statusWithType:YRStatusTypeInited];
}

+ (instancetype)loading {
  return [self statusWithType:YRStatusTypeLoading];
}

+ (instancetype)complete {
  return [self statusWithType:YRStatusTypeComplete];
}

- (instancetype)init {
  return [self initWithType:YRStatusTypeInited];
}

- (id __nonnull)initWithType:(YRStatusType)type {
  if (self = [super init]) {
    _type = type;
  }
  return self;
}

- (BOOL)isInited {
  return self.type == YRStatusTypeInited;
}

- (BOOL)isLoading {
  return self.type == YRStatusTypeLoading;
}

- (BOOL)isComplete {
  return self.type == YRStatusTypeComplete;
}

- (BOOL)notInited {
  return !self.isInited;
}

- (BOOL)notLoading {
  return !self.isLoading;
}

- (BOOL)notComplete {
  return !self.isComplete;
}

- (YRStatus *__nonnull)setInited {
  self.type = YRStatusTypeInited;
  return self;
}

- (YRStatus *__nonnull)setLoading {
  self.type = YRStatusTypeLoading;
  return self;
}

- (YRStatus *__nonnull)setComplete {
  self.type = YRStatusTypeComplete;
  return self;
}

- (YRStatusBoolConfigBlock)setPartial {
  return ^YRStatus *(BOOL value) {
    self.isPartial = value;
    return self;
  };
}

- (YRStatusBoolConfigBlock)setUpdated {
  return ^YRStatus *(BOOL value) {
    self.isUpdated = value;
    return self;
  };
}

- (YRStatusBoolConfigBlock)setFailed {
  return ^YRStatus *(BOOL value) {
    self.isFailed = value;
    return self;
  };
}

- (YRStatusBoolConfigBlock)setEmpty {
  return ^YRStatus *(BOOL value) {
    self.isEmpty = value;
    return self;
  };
}

- (YRStatusBoolConfigBlock)setHasMore {
  return ^YRStatus *(BOOL value) {
    self.isHasMore = value;
    return self;
  };
}

- (YRStatusBoolConfigBlock)setCached {
  return ^YRStatus *(BOOL value) {
    self.isCached = value;
    return self;
  };
}

- (YRStatus *)partial {
  self.isPartial = YES;
  return self;
}

- (YRStatus *)updated {
  self.isUpdated = YES;
  return self;
}

- (YRStatus *)failed {
  self.isFailed = YES;
  return self;
}

- (YRStatus *)empty {
  self.isEmpty = YES;
  return self;
}

- (YRStatus *)hasMore {
  self.isHasMore = NO;
  return self;
}

- (YRStatus *)cached {
  self.isCached = YES;
  return self;
}

- (YRStatus *)notPartial {
  self.isPartial = NO;
  return self;
}

- (YRStatus *)notUpdated {
  self.isUpdated = NO;
  return self;
}

- (YRStatus *)notFailed {
  self.isFailed = NO;
  return self;
}

- (YRStatus *)notEmpty {
  self.isEmpty = NO;
  return self;
}

- (YRStatus *)noMore {
  self.isHasMore = NO;
  return self;
}

- (YRStatus *)notCached {
  self.isCached = NO;
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  YRStatus *s = [YRStatus statusWithType:self.type];
  s.isPartial = self.isPartial;
  s.isUpdated = self.isUpdated;
  s.isFailed = self.isFailed;
  s.isEmpty = self.isEmpty;
  s.isHasMore = self.isHasMore;
  s.isCached = self.isCached;
  return s;
}

+ (BOOL)supportsSecureCoding {
  return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeInteger:self.type forKey:@"type"];
  [coder encodeBool:self.isPartial forKey:@"partial"];
  [coder encodeBool:self.isUpdated forKey:@"updated"];
  [coder encodeBool:self.isFailed forKey:@"failed"];
  [coder encodeBool:self.isEmpty forKey:@"empty"];
  [coder encodeBool:self.isHasMore forKey:@"more"];
  [coder encodeBool:self.isCached forKey:@"cached"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  if (self = [super init]) {
    self.type = (YRStatusType) [coder decodeIntegerForKey:@"type"];
    if (self.type < YRStatusTypeInited || self.type > YRStatusTypeComplete) {
      self.type = YRStatusTypeInited;
    }
    self.isUpdated = [coder decodeBoolForKey:@"updated"];
    self.isPartial = [coder decodeBoolForKey:@"partial"];
    self.isFailed = [coder decodeBoolForKey:@"failed"];
    self.isEmpty = [coder decodeBoolForKey:@"empty"];
    self.isHasMore = [coder decodeBoolForKey:@"more"];
    self.isCached = [coder decodeBoolForKey:@"cached"];
  }
  return self;
}

- (BOOL)isEqual:(YRStatus *)other {
  if (other == self)
    return YES;
  if (!other || ![[other class] isEqual:[self class]])
    return NO;

  return other.type == self.type &&
      other.isPartial == self.isPartial &&
      other.isUpdated == self.isUpdated &&
      other.isFailed == self.isFailed &&
      other.isEmpty == self.isEmpty &&
      other.isHasMore == self.isHasMore &&
      other.isCached == self.isCached;
}

- (NSString *)debugDescription {
  NSMutableString *description = [[NSMutableString alloc] initWithString:@"YRStatus<"];
  switch (self.type) {
    case YRStatusTypeInited: {
      [description appendString:@"Inited"];
      break;
    }
    case YRStatusTypeLoading: {
      [description appendString:@"Loading"];
      break;
    }
    case YRStatusTypeComplete: {
      [description appendString:@"Complete"];
      break;
    }
  }
  if (self.isPartial) {
    [description appendString:@",Partial"];
  }
  if (self.isUpdated) {
    [description appendString:@",Updated"];
  }
  if (self.isFailed) {
    [description appendString:@",Failed"];
  }
  if (self.isEmpty) {
    [description appendString:@",Empty"];
  }
  if (self.isHasMore) {
    [description appendString:@",HasMore"];
  }
  if (self.isCached) {
    [description appendString:@",Cached"];
  }
  [description appendString:@">"];
  return [description copy];
}

@end
