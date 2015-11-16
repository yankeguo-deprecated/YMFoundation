//
//  YMHTTPRequest.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/12.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMHTTPResponseTransformer.h"

/**
 *  HTTP请求类型
 */
typedef NS_ENUM(NSInteger, YMHTTPMethod) {
  /**
   *  GET
   */
      YMHTTPMethodGet,
  /**
   *  POST
   */
      YMHTTPMethodPost
};

@class YMHTTPRequest;

typedef void(^NSURLSessionDataTaskCompleteBlock)
    (NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error);

/**
 *  请求成功回调
 *
 *  @param response 返回结果
 */
typedef void(^YMHTTPRequestSuccessCallback)(id __nonnull response, YMHTTPRequest *__nonnull request);

/**
 *  请求失败回调
 *
 *  @param error 返回的错误
 */
typedef void(^YMHTTPRequestFailureCallback)(NSError *__nonnull error, YMHTTPRequest *__nonnull request);

/**
 *  请求结果回调，和前两个不冲突
 *
 *  @param error    错误
 *  @param response 结果
 */
typedef void
(^YMHTTPRequestCompleteCallback)(NSError *__nullable error, id __nullable response, YMHTTPRequest *__nonnull request);

@interface YMHTTPRequest: NSObject

/**
 *  请求路径
 */
@property(nonatomic, readonly, strong) NSString *__nonnull URLString;

/**
 *  HTTP 方法
 */
@property(nonatomic, readonly, assign) YMHTTPMethod method;

/**
 *  请求的参数，GET 放入 Query，POST 放入 Body，+default
 */
@property(nonatomic, readonly, strong) NSDictionary *__nullable params;

/**
 *  根据请求构建出来的 URLRequest
 */
@property(nonatomic, readonly, strong) NSURLRequest *__nullable URLRequest;

/**
 *  请求构建出来的 dataTask
 */
@property(nonatomic, readonly, strong) NSURLSessionDataTask *__nullable dataTask;

/**
 *  请求结果转换器, +default
 */
@property(nonatomic, readonly, strong) NSArray<id<YMHTTPResponseTransformer>> *__nullable responseTransformers;

/**
 *  成功回调, +default
 */
@property(nonatomic, readonly, retain) NSArray<YMHTTPRequestSuccessCallback> *__nullable successCallbacks;

/**
 *  失败回调，+default
 */
@property(nonatomic, readonly, retain) NSArray<YMHTTPRequestFailureCallback> *__nullable failureCallbacks;

/**
 *  完成回调, +default
 */
@property(nonatomic, readonly, retain) NSArray<YMHTTPRequestCompleteCallback> *__nullable completeCallbacks;

/**
 *  冻结该请求，使其不能被修改
 */
- (void)freeze;

/**
 *  返回一个可供配置的默认YMHTTPRequest
 *
 *  @return 默认YMHTTPRequest
 */
+ (instancetype __nonnull)defaultRequest;

/**
 *  构建一个GET请求
 *
 *  @param url 相对路径
 *
 *  @return 实例
 */
+ (instancetype __nonnull)buildGET:(NSString *__nonnull)url;

/**
 *  构建一个POST请求
 *
 *  @param url 相对路径
 *
 *  @return 实例
 */
+ (instancetype __nonnull)buildPOST:(NSString *__nonnull)url;

/**
 *  初始化一个请求
 *
 *  @param method 请求方法，GET/POST
 *  @param url    请求路径
 *
 *  @return 实例
 */
- (instancetype __nonnull)initWithMethod:(YMHTTPMethod)method url:(NSString *__nonnull)url;

/**
 *  添加一个请求参数
 *
 *  @param object 参数Value
 *  @param key    参数Key
 */
- (YMHTTPRequest *__nonnull)setParam:(id<NSCoding> __nullable)object forKey:(NSString *__nonnull)key;

/**
 *  从字典中添加多个参数请求
 *
 *  @param dict 字典
 *
 *  @return 自己
 */
- (YMHTTPRequest *__nonnull)addParams:(NSDictionary *__nonnull)dict;

/**
 *  移除全部请求转换器
 *
 *  @return 自己
 */
- (YMHTTPRequest *__nonnull)removeAllResposeTransformers;

/**
 *  注册一个请求返回转换器
 *
 *  @param transformer 转换器
 *
 *  @return 自己
 */
- (YMHTTPRequest *__nonnull)addResponseTransformer:(id<YMHTTPResponseTransformer> __nonnull)transformer;

/**
 *  移除一个请求结果验证器
 *
 *  @param transformer 转换器
 *
 *  @return 自己
 */
- (YMHTTPRequest *__nonnull)removeResponseTransformerByClass:(Class __nonnull)transformerClass;

/**
 *  设置成功回调
 *
 *  @param success 成功回调
 *
 *  @return 自己
 */
- (YMHTTPRequest *__nonnull)onSuccess:(YMHTTPRequestSuccessCallback __nonnull)success;

/**
 *  设置失败回调
 *
 *  @param failure 失败回调
 *
 *  @return 自己
 */
- (YMHTTPRequest *__nonnull)onFailure:(YMHTTPRequestFailureCallback __nonnull)failure;

/**
 *  设置完成回调，和前两个并不冲突
 *
 *  @param complete 完成回调
 *
 *  @return 自己
 */
- (YMHTTPRequest *__nonnull)onComplete:(YMHTTPRequestCompleteCallback __nonnull)complete;

/**
 *  构建 URLRequest
 */
- (void)buildRequest;

/**
 *  执行请求
 */
- (void)execOn:(NSURLSession *__nonnull)session;

@end
