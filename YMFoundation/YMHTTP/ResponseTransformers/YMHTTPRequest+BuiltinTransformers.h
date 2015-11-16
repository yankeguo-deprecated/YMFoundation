//
//  YMHTTPRequest+BuiltinTransformers.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMHTTPRequest.h"

@interface YMHTTPRequest (BuiltinTransformers)

/**
 *  使用 YMJSONResponseTransformer
 */
- (void)useJSONResponse;

/**
 *  将请求的返回结果重新转换为一个 keyPath 上的值
 *
 *  @param keyPath keyPath
 */
- (void)addKeyPathTransform:(NSString *)keyPath;

/**
 *  添加一个 类型验证 Transformer
 *
 *  @param model 类型
 */
- (void)addClassCheckTransform:(Class)model;

/**
 *  将请求的返回结果映射为一个 JSONModel
 *
 *  @param model JSONModel 类
 */
- (void)addModelObjectTransform:(Class)model;

/**
 *  将请求的返回结果映射为一个 JSONModel 数组
 *
 *  @param model JSONModel 类
 */
- (void)addModelArrayTransform:(Class)model;

/**
 *  移除已经存在的上两个Transformer
 */
- (void)removeModelTransform;

@end
