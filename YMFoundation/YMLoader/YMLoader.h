//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMLoaderProxy.h"

typedef id __nonnull (^YMLoaderObjectFactory)();

@interface YMLoader: NSObject

/**
 * Get the shared loader
 */
+ (YMLoader *__nonnull)sharedLoader;

/**
 * Register a raw object for key
 *
 * @param object the object for registration
 * @param key loader key
 */
- (void)registerObject:(id __nonnull)object forKey:(NSString* __nonnull)key;

/**
 * Register a factory for key
 *
 * @param objectFactory a block providing a object
 * @param key loader key
 */
- (void)registerFactory:(YMLoaderObjectFactory __nonnull)objectFactory forKey:(NSString* __nonnull)key;

/**
 * Get a registered object
 *
 * @param loaderKey
 * @return object
 */
- (id __nullable)objectForKey:(NSString* __nonnull)key;

/**
 * Get a registered object
 *
 * @param loaderKey
 * @return object
 */
- (id __nullable)objectForKeyedSubscript:(NSString* __nonnull)key;

/**
 * @param loader key
 *
 * @return whether this loader has object for key
 */
- (BOOL)hasObjectForKey:(NSString* __nonnull)key;

@end