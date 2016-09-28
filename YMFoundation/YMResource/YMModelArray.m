//
//  YMLazyModelArray.m
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import "YMModelArray.h"

#import <YMFoundation/YMUtils.h>
#import <YMFoundation/YMRAC.h>

@implementation YMModelArray {
  NSMutableArray *_modelIdsArray;
}

#pragma mark - Resource Management

+ (NSSet<NSString *> *__nonnull)keyPathsForValuesAffectingStatus {
  return [NSSet setWithObject:@"adapter.statusPair"];
}

+ (NSSet<NSString *> *__nonnull)keyPathsForValuesAffectingStatusPair {
  return [NSSet setWithObject:@"adapter.statusPair"];
}

- (YMAsyncQueue *)queue {
  return self.adapter.queue;
}

- (YRStatusPair *)statusPair {
  return self.adapter.statusPair;
}

- (void)setStatusPair:(YRStatusPair *)statusPair {
  self.adapter.statusPair = statusPair;
}

- (YRStatus *)status {
  return self.adapter.status;
}

- (void)setStatus:(YRStatus *)status {
  self.adapter.status = status;
}

- (void)appendStatus:(YRStatus *__nonnull)status {
  [self.adapter appendStatus:status];
}

#pragma mark - Init

- (id)init {
  if (self = [super init]) {
    _modelIdsArray = [[NSMutableArray alloc] init];
    self.adapter = [[YRAdapter alloc] init];
  }
  return self;
}

- (id)initWithModelStore:(YMModelStore *)modelStore {
  if (self = [self init]) {
    NSParameterAssert(modelStore != nil);
    _modelStore = modelStore;
    self.adapter = [[YRAdapter alloc] init];
  }
  return self;
}

- (Class)modelClass {
  return self.modelStore.modelClass;
}

- (NSArray<NSString *> *)allIds {
  return [_modelIdsArray copy];
}

- (NSUInteger)count {
  return _modelIdsArray.count;
}

- (BOOL)isEmpty {
  return self.count == 0;
}

- (BOOL)updateIdsArray:(NSArray<NSString *> *)idsArray {
  __block NSString *current;
  __block NSString *last;
  @synchronized (self) {
    last = [self characteristicString];
    [_modelIdsArray removeAllObjects];
    [_modelIdsArray addObjectsFromArray:idsArray];
    current = [self characteristicString];
  }
  return NSStringNotEquals(last, current);
}

- (BOOL)appendIdsArray:(NSArray<NSString *> *__nonnull)idsArray {
  BOOL ok = idsArray.count > 0;
  [_modelIdsArray addObjectsFromArray:idsArray];
  return ok;
}

- (BOOL)removeAllIds {
  BOOL ok = _modelIdsArray.count > 0;
  if (ok) [_modelIdsArray removeAllObjects];
  return ok;
}

- (BOOL)removeId:(NSString *__nonnull)id {
  BOOL ok = [_modelIdsArray containsObject:id];
  [_modelIdsArray removeObject:id];
  return ok;
}

- (NSString *)modelIdAtIndex:(NSUInteger)index {
  return [_modelIdsArray objectOrNilAtIndex:index];
}

- (YMModel *)firstModel {
  if (self.count == 0) return nil;
  return [self modelAtIndex:0];
}

- (YMModel *)lastModel {
  if (self.count == 0) return nil;
  return [self modelAtIndex:self.count - 1];
}

- (NSString *__nullable)firstModelId {
  return _modelIdsArray.firstObject;
}

- (NSString *__nullable)lastModelId {
  return _modelIdsArray.lastObject;
}

- (id)modelAtIndex:(NSUInteger)index {
  NSString *id = [self modelIdAtIndex:index];
  if (id == nil) return nil;
  return self.modelStore[id];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
  return [self modelAtIndex:idx];
}

- (NSArray *__nullable)toArray {
  return [_modelIdsArray.rac_sequence map:^id(NSString *id) {
    return [self.modelStore modelForId:id];
  }].array;
}

- (NSString *__nullable)characteristicString {
  return [_modelIdsArray componentsJoinedByString:@"|"];
}

@end
