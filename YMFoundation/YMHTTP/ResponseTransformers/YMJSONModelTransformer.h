//
//  YMJSONModelTransformer.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMHTTPResponseTransformer.h"

@interface YMJSONModelTransformer: NSObject<YMHTTPResponseTransformer>

/**
 *  模型类
 */
@property(nonatomic, assign) Class __nonnull modelClass;

/**
 *  是否为 NSArray 转换目标
 */
@property(nonatomic, assign, getter=isModelArray) BOOL modelArray;

/**
 *  初始化一个 JSONModel 转换器
 *
 *  @param clazz   JSONModel 类
 *  @param isArray 是否为 NSArray
 *
 *  @return 实例
 */
+ (instancetype __nonnull)transformerWithModelClass:(Class __nonnull)clazz isArray:(BOOL)isArray;

- (id __nonnull)initWithModelClass:(Class __nonnull)clazz isArray:(BOOL)isArray;

@end
