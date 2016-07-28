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

- (id)init {
  NSParameterAssert(NO);
  return nil;
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
  NSParameterAssert(id != nil);

  __block YMModel *model = nil;

  @synchronized (self) {
    //  Find model
    model = [_mapTable objectForKey:id];
    //  Create if not found
    if (model == nil) {
      model = [[_modelClass alloc] init];
      NSParameterAssert(model != nil);
      model.id = [id copy];

      [_mapTable setObject:model forKey:id];
    }
  }

  return model;
}

- (YMModel *)objectForKeyedSubscript:(NSString *)key {
  return [self modelForId:key];
}

@end
