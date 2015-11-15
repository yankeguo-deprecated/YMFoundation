//
//  YMJSONTransformer.h
//  ProtoJSON
//
//  Created by 琰珂 郭 on 15/9/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMJSONTransformer: NSObject

+ (instancetype __nonnull)shared;

+ (BOOL)canTransformJSONObjectToClass:(Class __nonnull)cls;

+ (BOOL)canTransformJSONObjectToClass:(Class __nonnull)cls withGeneric:(Class __nonnull)genericCls;

- (id __nullable)transformJSONObjectFrom:(id __nonnull)jsonObject toClass:(Class __nonnull)cls;

- (id __nullable)transformJSONObjectFrom:(id __nonnull)jsonObject toClass:(Class __nonnull)cls genericClass:(Class __nonnull)genericCls;

// String

- (NSString *__nullable)NSStringFromJSONObject:(id __nonnull)object;

- (NSMutableString *__nonnull)NSMutableStringFromJSONObject:(id __nonnull)object;

// Number

- (NSNumber *__nullable)NSNumberFromJSONObject:(id __nonnull)object;

- (NSDecimalNumber *__nullable)NSDecimalNumberFromJSONObject:(id __nonnull)object;

// Dictionary

- (NSDictionary *__nullable)NSDictionaryFromJSONObject:(id __nonnull)object;

- (NSMutableDictionary *__nullable)NSMutableDictionaryFromJSONObject:(id __nonnull)object;

- (NSDictionary *__nullable)NSDictionaryFromJSONObject:(id __nonnull)object genericClass:(Class __nonnull)genericClass;

- (NSMutableDictionary *__nullable)NSMutableDictionaryFromJSONObject:(id __nonnull)object genericClass:(Class __nonnull)genericClass;

// Array

- (NSArray *__nullable)NSArrayFromJSONObject:(id __nonnull)object;

- (NSMutableArray *__nullable)NSMutableArrayFromJSONObject:(id __nonnull)object;

- (NSArray *__nullable)NSArrayFromJSONObject:(id __nonnull)object genericClass:(Class __nonnull)genericClass;

- (NSMutableArray *__nullable)NSMutableArrayFromJSONObject:(id __nonnull)object genericClass:(Class __nonnull)genericClass;

// Set

- (NSSet *__nullable)NSSetFromJSONObject:(id __nonnull)object;

- (NSMutableSet *__nullable)NSMutableSetFromJSONObject:(id __nonnull)object;

- (NSSet *__nullable)NSSetFromJSONObject:(id __nonnull)object genericClass:(Class __nonnull)genericClass;

- (NSMutableSet *__nullable)NSMutableSetFromJSONObject:(id __nonnull)object genericClass:(Class __nonnull)genericClass;

@end

@interface YMJSONTransformer (ReversTransforming)

/**
 *  是否将一个类转换为 YMJSON 初级对象（自动尝试用父类进行匹配，自动处理 Cluster Class）
 *
 *  @param cls 类
 *
 *  @return YES 如果可以转换
 */
+ (BOOL)canTransformClassToJSONObject:(Class __nonnull)cls;

/**
 *  将一个类的实例转换为 YMJSON 初级对象（自动尝试用父类进行匹配，自动处理 Cluster Class）
 *
 *  @param object 实例
 *
 *  @return YMJSON 初级对象
 */
- (id __nonnull)transformToJSONObject:(id __nonnull)object;

- (id __nonnull)JSONObjectFromNSString:(NSString *__nonnull)object;

- (id __nonnull)JSONObjectFromNSNumber:(NSNumber *__nonnull)object;

- (id __nonnull)JSONObjectFromNSDecimalNumber:(NSDecimalNumber *__nonnull)object;

- (id __nonnull)JSONObjectFromNSArray:(NSArray *__nonnull)object;

- (id __nonnull)JSONObjectFromNSDictionary:(NSDictionary *__nonnull)object;

- (id __nonnull)JSONObjectFromNSSet:(NSSet *__nonnull)object;

@end