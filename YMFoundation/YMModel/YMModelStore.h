//
//  YMModelStore.h
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//  YMModelStore 提供了一个单例模式下的 YMModel 存储和查询空间

#import <Foundation/Foundation.h>

#import "YMModelProvider.h"

@class YMModel;

@interface YMModelStore<ObjectType : __kindof YMModel*> : NSObject<YMModelProvider>

@property(nonatomic, strong) Class __nonnull modelClass;

@property(nonatomic, assign) NSUInteger count;

- (id __nonnull)initWithModelClass:(Class __nonnull)modelCls;

/**
 *  Find or create a YMModel for id
 *
 *  @param id id
 *
 *  @return YMModel found or created
 */
- (ObjectType __nonnull)modelForId:(NSString *__nonnull)id;

- (ObjectType __nonnull)objectForKeyedSubscript:(NSString *__nonnull)key;

@end
