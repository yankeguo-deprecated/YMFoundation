//
// Created by Yanke Guo on 15/11/14.
// Copyright (c) 2015 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Load the YMLocale system
 */
extern void YMLocaleLoad(BOOL cacheEnabled);

/**
 * Get a localized string from key
 */
extern NSString* __nonnull T(NSString* __nonnull key);

/**
 * Get a localized string from key
 */
#define L(KEY) T(@#KEY)

@interface YMLocale: NSObject

/**
 * Get a shared sharedLocale
 */
+ (YMLocale * __nonnull)sharedLocale;

/**
 * Load bundled *.locale.plist files
 */
- (void)loadWithCacheEnabled:(BOOL)cacheEnabled;

/**
 * Register a i18n value to key manually
 *
 * @param key
 * @param value
 */
- (void)registerLocalizedString:(NSString* __nonnull)value forKey:(NSString* __nonnull)key;

/**
 * Get a localized string for key
 *
 * @param key
 * @return localized string
 */
- (NSString* __nonnull)localizedStringForKey:(NSString* __nonnull)key;

@end
