//
//  YMLazyModelArray.m
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import "YMIndexedModelArray.h"
#import "YMModelStore.h"

#import <YMFoundation/YMUtils.h>

@implementation YMIndexedModelArray {
  NSMutableArray *_modelIdsArray;
}

- (NSUInteger)count {
  return _modelIdsArray.count;
}

- (id)init {
  NSParameterAssert(NO);
  return nil;
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

- (id)initWithModelStore:(YMModelStore *)modelStore {
  if (self = [super init]) {
    NSParameterAssert(modelStore != nil);

    _modelIdsArray = [[NSMutableArray alloc] init];
    _modelClass = modelStore.modelClass;
    _modelStore = modelStore;
  }
  return self;
}

- (NSString *)modelIdAtIndex:(NSUInteger)index {
  return [_modelIdsArray objectOrNilAtIndex:index];
}

- (id)modelAtIndex:(NSUInteger)index {
  NSString *id = [self modelIdAtIndex:index];
  if (id == nil) return nil;
  return self.modelStore[id];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
  return [self modelAtIndex:idx];
}

- (NSString *__nullable)characteristicString {
  return [_modelIdsArray componentsJoinedByString:@"|"];
}

@end
