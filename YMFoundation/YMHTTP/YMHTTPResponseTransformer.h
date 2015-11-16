//
//  YMHTTPResponseTransformer.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMHTTPRequest;

@protocol YMHTTPResponseTransformer<NSObject>

/**
 *  验证，并转换请求结果
 *
 *  错误和返回值不能全部为空，也不能全部存在
 *
 *  @param response 请求返回结果，NSDictionary 或者 NSArray
 *  @param error    错误输出
 *  
 *  @return 经过转换后的结果
 */
- (id __nullable)transformResponse:(id __nullable)response error:(NSError *__nullable *__nonnull)error request:(YMHTTPRequest *__nonnull)request;

@end
