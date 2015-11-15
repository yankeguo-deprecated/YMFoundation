//
//  YMJSON.h
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMJSONDescriptor.h"
#import "YMJSONMappingItem.h"
#import "YMJSONTransformer.h"

@protocol AbstractJSON<NSObject>

- (id __nullable)initWithDictionary:(NSDictionary *__nonnull)dict;

- (NSDictionary *__nonnull)toDictionaryWithKeys:(NSArray<NSString *> *__nullable)keys;

@end

@interface YMJSON: NSObject<AbstractJSON, NSCopying>

/**
 *  构建一个 YMJSONDescriptor，默认实现为空，需要子类复写
 *
 *  @param descriptor YMJSONDescriptor
 */
+ (void)buildDescriptor:(YMJSONDescriptor *__nonnull)descriptor;

/**
 *  从一个 YMJSON 字典初始化子类
 *
 *  @param dict 字典
 *
 *  @return 实例，或者 nil
 */
- (id __nullable)initWithDictionary:(NSDictionary *__nonnull)dict;

- (id __nullable)initWithString:(NSString *__nonnull)string;

+ (NSArray *__nullable)arrayFromDictionaries:(NSArray<NSDictionary *> *__nonnull)dictionaries;

- (NSDictionary *__nonnull)toDictionary;

- (NSDictionary *__nonnull)toDictionaryWithKeys:(NSArray<NSString *> *__nullable)keys;

- (NSString *__nonnull)toJSONString;

/**
 *  可供子类覆盖，做一些基础验证，和额外初始化
 *
 *  @return YES 如果验证成功
 */
- (BOOL)validate;

/**
 *  NSCopy
 */
- (id __nonnull)copyWithZone:(NSZone *__nullable)zone;

@end
