//
//  YMKeyPathTransformer.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMHTTPResponseTransformer.h"

@interface YMKeyPathTransformer: NSObject<YMHTTPResponseTransformer>

/**
 *  KeyPath
 */
@property(nonatomic, strong, readonly) NSString *__nonnull keyPath;

/**
 *  初始化 一个 KeyPath 转换器
 *
 *  @param keyPath KeyPath
 *
 *  @return 实例
 */
+ (instancetype __nonnull)transformerWithKeyPath:(NSString *__nonnull)keyPath;

- (id __nonnull)initWithKeyPath:(NSString *__nonnull)keyPath;

@end
