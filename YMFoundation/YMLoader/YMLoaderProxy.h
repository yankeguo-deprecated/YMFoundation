//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMLoader;

@interface YMLoaderProxy: NSObject

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *__nonnull registry;

/**
 * Get the loader used in this proxy, default implementation use [YMLoader sharedLoader]
 *
 * For subclass
 *
 * @return YMLoader
 */
- (YMLoader *__nonnull)loader;

/**
 * This method will be called after init
 *
 * For subclass
 */
- (void)build;

/**
 * Initialize a new proxy
 */
+ (instancetype __nonnull)proxy;

+ (instancetype __nonnull)new;

- (instancetype __nonnull)init;

/**
 * Use a loader factory key for selector
 */
- (void)use:(NSString *__nonnull)loaderKey forSelector:(SEL __nonnull)aSelector;

/**
 *  是否相应某 SEL
 *
 *  @param aSelector SEL
 *
 *  @return 是否
 */
- (BOOL)respondsToSelector:(SEL __nonnull)aSelector;

@end