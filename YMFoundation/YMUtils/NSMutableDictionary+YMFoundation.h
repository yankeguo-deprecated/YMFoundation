//
// Created by Yanke Guo on 15/11/17.
// Copyright (c) 2015 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary<KeyType, ObjectType> (YMFoundation)

/**
 *  注册一个 valueFactory, 在此情况下可以使用 objectDefiniteForKey
 */
@property(nonatomic, strong) ObjectType __nonnull(^ __nonnull valueFactory)();

/**
 *  在 valueFactory 存在的情况下, 如果为 nil 自动创建对象
 */
- (ObjectType __nonnull)objectDefiniteForKey:(KeyType)key;

@end