//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import "NSObject+YMLoader.h"

#import "YMLoader.h"

#import "YMLogger.h"
#import "YMUtilsSuppressMacros.h"

@implementation NSObject (YMLoader)

- (YMLoader *__nonnull)loader {
  return [YMLoader sharedLoader];
}

- (void)buildDepencencies:(NSMutableDictionary<NSString *, NSString *> *)dependencies {
#ifdef DEBUG
  dependencies[@"__ping"] = @"1";
#endif
}

- (void)buildProvides:(NSMutableArray<NSString *> *)provides {
#ifdef DEBUG
  [provides addObject:@"__ping"];
#endif
}

- (void)injectDependencies {
  NSMutableDictionary<NSString *, NSString *> *dependencies = [NSMutableDictionary new];
  [self buildDepencencies:dependencies];
#ifdef DEBUG
  NSAssert([dependencies objectForKey:@"__ping"], @"Please call [super buildDependencies:] !!");
  [dependencies removeObjectForKey:@"__ping"];
#endif
  [dependencies enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key,
                                                    NSString *_Nonnull obj,
                                                    BOOL *_Nonnull stop) {
    NSString *first = [[key substringToIndex:1] uppercaseString];
    NSString *remainning = [key substringFromIndex:1];
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", first, remainning];
    id result = [[self loader] objectForKey:obj];
    if (result == nil) {
      ELog(@"[GlobalInjector] Missing Injection: %@ for %@.%@", obj, self, key);
    }

    SUPPRESS_START
    SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
    [self performSelector:sel_getUid(setter.UTF8String) withObject:result];
    SUPPRESS_END
  }];
}

- (void)declareProvides {
  NSMutableArray<NSString *> *provides = [NSMutableArray new];
  [self buildProvides:provides];
#ifdef DEBUG
  NSAssert([provides containsObject:@"__ping"], @"Please call [super buildProvides:]");
  [provides removeObject:@"__ping"];
#endif
  [provides enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    [[self loader] registerObject:self forKey:obj];
  }];
}

@end