//
// Created by Yanke Guo on 15/11/17.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (YMFoundation)

/**
 * Set if object is not nil, remove if object is nil
 */
- (void)setOrRemoveObject:(id __nullable)object forKey:(NSString *__nonnull)key;

@end