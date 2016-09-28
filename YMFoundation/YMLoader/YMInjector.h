//
// Created by Yanke Guo on 16/7/29.
// Copyright (c) 2016 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Helper Protocols

/* 该属性应该要自动创建出来 -init */
@protocol AutoCreate
@end

/* 注入流程会自动蔓延到改属性上去 */
@protocol Propagate
@end

/* 该属性会自动被注入 */
@protocol AutoInject
@end

@interface NSObject (YMCoreInitHelper)<AutoCreate, Propagate, AutoInject>

- (void)didInjected;

@end

@interface YMInjector : NSObject

/* 执行自动创建流程, 同时把创建好的东西缓存下来; 调用 dispose 可以释放掉自动缓存的东西 */
- (void)executeAutoCreateOn:(NSObject *__nonnull)target;

- (void)executeAutoInjectOn:(NSObject *__nonnull)target;

- (void)registerObject:(NSObject *__nonnull)object forKey:(NSString *__nonnull)key;

- (NSObject *__nullable)objectForKey:(NSString *__nonnull)key;

- (void)removeObjectForKey:(NSString *__nonnull)key;

/* 释放之前自动缓存的东西 */
- (void)dispose;

@end