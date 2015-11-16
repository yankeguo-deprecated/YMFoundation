//
// Created by Yanke Guo on 15/11/16.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YMFoundation)

/**
 *  Flatten this dictionary into dot joined key
 */
- (NSDictionary<NSString*, NSString*>* __nonnull)flattenedDictionary;

@end