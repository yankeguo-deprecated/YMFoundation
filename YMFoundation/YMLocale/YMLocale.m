//
// Created by Yanke Guo on 15/11/14.
// Copyright (c) 2015 YANKE Guo. All rights reserved.
//

#import "YMLocale.h"

#import "YMLogger.h"
#import "YMUtilsSystemInfoMacros.h"
#import "NSDictionary+YMFoundation.h"

void YMLocaleLoad(BOOL cacheEnabled) {
  [[YMLocale sharedLocale] loadWithCacheEnabled:cacheEnabled];
}

NSString* T(NSString* __nonnull key) {
  return [[YMLocale sharedLocale] localizedStringForKey:key];
}

@interface YMLocale () {
  NSString *_cachePath;
}

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *store;

@end

@implementation YMLocale

+ (YMLocale *)sharedLocale {
  static YMLocale *_instance = nil;

  @synchronized (self) {
    if (_instance == nil) {
      _instance = [[self alloc] init];
    }
  }

  return _instance;
}

- (void)loadWithCacheEnabled:(BOOL)cacheEnabled {
  //  Try to load from cache

  //  Ensure directory
  [[NSFileManager defaultManager] createDirectoryAtPath:[_cachePath stringByDeletingLastPathComponent]
                            withIntermediateDirectories:YES
                                             attributes:nil
                                                  error:nil];

  //  Load cache
  NSDictionary *cachedStore = [NSDictionary dictionaryWithContentsOfFile:_cachePath];

  if (cachedStore == nil || !cacheEnabled) {
    NSMutableDictionary *allStore = [[NSMutableDictionary alloc] init];

    //  Get all files
    NSArray<NSURL *> *URLs = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"locale.plist" subdirectory:nil];
    [URLs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSURL *obj, NSUInteger idx, BOOL *stop) {
      DLog(@"Locale File Loaded: %@", [obj path]);
      NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:obj];
      if (dictionary) {
        [allStore addEntriesFromDictionary:dictionary];
      }
    }];

    //  Flatten and save to self.store
    [self.store addEntriesFromDictionary:[(NSDictionary *) allStore flattenedDictionary]];

    DLog(@"Cache file created: %@", _cachePath);
    DLog(@"%@ entries written.", @(self.store.count));

    //  Save cache
    [[self.store copy] writeToFile:_cachePath atomically:YES];
  } else {
    //  Load to self.store
    [self.store addEntriesFromDictionary:cachedStore];

    DLog(@"%@ entries load from cache.", @(self.store.count));
  }

  // Print all i18n
  DLog(@"i18n file start ========");
  [[[self.store allKeys] sortedArrayUsingSelector:@selector(compare:)] enumerateObjectsUsingBlock:^(NSString *_Nonnull obj,
                                                                                                    NSUInteger idx,
                                                                                                    BOOL *_Nonnull stop) {
    DLog(@"%@ = %@", obj, [self localizedStringForKey:obj]);
  }];
  DLog(@"i18n file end ========");
}

- (id)init {
  if (self = [super init]) {
    self.store = [[NSMutableDictionary alloc] init];
    NSString *localeIdf = [NSLocale currentLocale].localeIdentifier;
    NSString *cacheFileName = [NSString stringWithFormat:@"build%@.%@.cache.plist", AppVersionLong, localeIdf];
    _cachePath =
        [[AppCacheDirectory stringByAppendingPathComponent:@"locale"] stringByAppendingPathComponent:cacheFileName];
  }
  return self;
}

- (void)registerLocalizedString:(NSString *__nonnull)value forKey:(NSString *__nonnull)key {
  if (value == nil || key == nil) return;

  self.store[key] = value;
}

- (NSString *)localizedStringForKey:(NSString *)key {
  if (key == nil) return @"";
  NSString *value = [self.store valueForKeyPath:key];
  if (value == nil) return key;
  return value;
}

@end