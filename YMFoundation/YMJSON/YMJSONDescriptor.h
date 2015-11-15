//
//  YMJSONDescriptor.h
//  ProtoJSON
//
//  Created by 琰珂 郭 on 15/9/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMJSONMappingItem.h"

@protocol AbstractJSON;

@interface YMJSONDescriptor: NSObject

/**
 *  为某个 YMJSON 子类创建描述
 *
 *  @param cls 子类
 *
 *  @return 描述
 */
+ (instancetype __nonnull)descriptorForClass:(Class __nonnull)cls;

/**
 *  同上，创建描述
 *
 *  @param cls 子类
 *
 *  @return 描述
 */
- (id __nonnull)initWithClass:(Class __nonnull)cls;

/**
 *  将 YMJSON 解析出来的字典应用到一个 YMJSON 子类上
 *
 *  @param dict   字典
 *  @param object 要应用的目标，目标必须和描述符创建时的类一致
 *
 *  @return 应用是否成功
 */
- (BOOL)applyDictionary:(NSDictionary *__nonnull)dict toObject:(id __nonnull)object;

/**
 *  将目标转换为 YMJSON 字典
 *
 *  @param object 目标
 *  @param keys   要转换的 key，nil 则表示全部转换
 *
 *  @return 转换出来的 YMJSON 字典
 */
- (NSDictionary *__nonnull)toDictionaryWithObject:(id __nonnull)object keys:(NSArray<NSString *> *__nullable)keys;

/**
 *  注册一组属性为 Optional (可选为nil）
 *
 *  @param propertyNames 属性名
 */
- (void)addAll:(NSArray<NSString *> *__nonnull)propertyNames;

/**
 *  注册一个属性为 Optional（可选为 nil）
 *
 *  @param propertyName 属性名
 */
- (void)add:(NSString *__nonnull)propertyName;


/**
 *  注册一个属性为 Optional，并制定 YMJSON 的字段名
 *
 *  @param propertyName 属性名
 *  @param fieldName    字段名
 */
- (void)add:(NSString *__nonnull)propertyName fieldName:(NSString *__nonnull)fieldName;

/**
 *  注册一组属性为 Required，（必选，否则解析失败）
 *
 *  @param propertyNames 属性名
 */
- (void)addAllRequired:(NSArray<NSString *> *__nonnull)propertyNames;

/**
 *  注册一个属性为 Required，（必选，否则解析失败）
 *
 *  @param propertyName 属性名
 */
- (void)addRequired:(NSString *__nonnull)propertyName;

/**
 *  注册一个属性为 AutoFill（可选，自动填充空值）
 *
 *  @param propertyName 属性名
 */
- (void)addAutoFill:(NSString *__nonnull)propertyName;

/**
 *  注册一个 Required 容器类型的属性，当前支持 NS(Mutable)Array, NS(Mutable)Dictionary, NS(Mutable)Set
 *
 *  @param propertyName 属性名
 *  @param genericClass 容器内部的类型，支持原始类型和 YMJSON 子类
 */
- (void)addRequired:(NSString *__nonnull)propertyName genericClass:(Class __nonnull)genericClass;

/**
 *  注册一个 Optional 容器类型的属性，当前支持 NS(Mutable)Array, NS(Mutable)Dictionary, NS(Mutable)Set
 *
 *  @param propertyName 属性名
 *  @param genericClass 容器内部的类型，支持原始类型和 YMJSON 子类
 */
- (void)add:(NSString *__nonnull)propertyName genericClass:(Class __nonnull)genericClass;

/**
 *  注册一个属性
 *
 *  @param propertyName 属性名
 *  @param build        构造器
 */
- (void)add:(NSString *__nonnull)propertyName build:(void (^ __nullable)(YMJSONMappingItem *__nonnull mapping))build;

@end
