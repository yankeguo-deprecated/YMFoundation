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

@interface YMModelStore<ObjectType : YMModel *> : NSObject<YMModelProvider>

@property(nonatomic, strong) Class __nonnull modelClass;

@property(nonatomic, assign) NSUInteger count;

/**
 *  Standard initialization
 *
 *  @param modelCls model class
 *
 *  @return self
 */
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

- (NSDictionary<NSString*, ObjectType> *__nonnull)toDictionary;

#pragma mark - Subclass

/**
 *  For subclass, called when a whole new model is created, default implementation does nothing
 *
 *  @param model model
 */
- (void)didCreateModel:(ObjectType __nonnull)model;

/**
 *  Override this method in subclass and you can use shortcut initialization
 *
 *  @return model class to use
 */
+ (Class __nonnull)modelClass;

/**
 *  Shortcut initialization, +modelClass must be overriden
 *
 *  @return instance
 */
+ (instancetype __nonnull)modelStore;

- (id __nonnull)init;

@end
