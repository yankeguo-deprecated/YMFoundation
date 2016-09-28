//
//  YMModelStore.m
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import <YMFoundation/YMAsync.h>

#import "YMModel.h"
#import "YMModelStore.h"

@implementation YMModelStore {
  NSMapTable<NSString *, id> *_mapTable;
}

- (NSUInteger)count {
  return _mapTable.count;
}

- (id)initWithModelClass:(Class)modelCls {
  if (self = [super init]) {
    NSParameterAssert(modelCls != NULL);
    NSParameterAssert([modelCls isSubclassOfClass:[YMModel class]]);

    _modelClass = modelCls;
    _mapTable = [NSMapTable strongToStrongObjectsMapTable];
  }
  return self;
}

- (YMModel *)modelForId:(NSString *)id {
  //  Use __NIL_ID__ as default
  id = id ?: YMModelNilId;

  __block YMModel *model = nil;

  @synchronized (self) {
    //  Find model
    model = [_mapTable objectForKey:id];
    //  Create if not found
    if (model == nil) {
      model = [[_modelClass alloc] init];
      NSParameterAssert(model != nil);
      model.id = [id copy];
      [self didCreateModel:model];

      [_mapTable setObject:model forKey:id];
    }
  }

  return model;
}

- (YMModel *)objectForKeyedSubscript:(NSString *)key {
  return [self modelForId:key];
}

- (NSDictionary *__nonnull)toDictionary {
  return [_mapTable dictionaryRepresentation];
}

- (void)didCreateModel:(__kindof YMModel *)model {}

+ (Class)modelClass {
  NSParameterAssert(NO);
  return NULL;
}

+ (instancetype)modelStore {
  return [[[self class] alloc] init];
}

- (id)init {
  return [[[self class] alloc] initWithModelClass:[[self class] modelClass]];
}

@end
