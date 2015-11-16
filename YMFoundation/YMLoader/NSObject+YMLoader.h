//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMLoader;

@interface NSObject (YMLoader)

/**
 * 所使用的 YMLoader,默认实现为 [YMLoader sharedLoader]
 *
 * @return YMLoader
 */
- (YMLoader* __nonnull)loader;

/**
 *  构建依赖信息, for subclass
 *
 *  @param dependencies, key 为 属性, value 为 loader key
 */
- (void)buildDepencencies:(NSMutableDictionary<NSString *, NSString *> *__nonnull)dependencies;

/**
 *  构建声明信息, for subclass
 *
 *  @param provides, key 为 loader key
 */
- (void)buildProvides:(NSMutableArray<NSString *> *__nonnull)provides;

/**
 *  执行注入，参考 buildDependencies
 */
- (void)injectDependencies;

/**
 *  将自己注册为依赖项，参考 buildProvides
 */
- (void)declareProvides;

@end