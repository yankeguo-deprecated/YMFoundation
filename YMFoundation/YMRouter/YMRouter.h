//
//  YMRouter.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/16.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YMAbstractRouter<NSObject>

- (BOOL)routeUrl:(NSURL *__nonnull)url;

@end

typedef void(^YMRouterAction)(NSDictionary<NSString *, NSString *> *__nonnull params);

@interface YMRouter: NSObject<YMAbstractRouter>

/**
 *  当前 YMRouter 的 Scheme
 */
@property(nonatomic, readonly, copy) NSString *__nonnull scheme;

/**
 *  初始化一个 Router 并制定默认 Scheme
 *
 *  @param scheme Scheme
 *
 *  @return 实例
 */
+ (instancetype __nonnull)routerWithScheme:(NSString *__nonnull)scheme;

- (id __nonnull)initWithScheme:(NSString *__nonnull)scheme;

/**
 *  为某个Scheme注册一个 子 Router，比如说微信支付和支付宝支付回调
 *  如果子 Router 和当前 Router Scheme 相同，子 Router 会以低优先级调用
 *
 *  @param router 子Router
 *  @param scheme Scheme
 */
- (void)registerRouter:(id<YMAbstractRouter> __nonnull)router forScheme:(NSString *__nonnull)scheme;

/**
 *  根据一个 url 进行跳转
 *
 *  @param url URL
 */
- (BOOL)routeUrl:(NSURL *__nonnull)url;

- (BOOL)routeUrlString:(NSString *__nonnull)url;

/**
 *  根据默认 Scheme 来跳转
 *
 *  @param fullPath 完整带参数路径
 */
- (BOOL)routePath:(NSString *__nonnull)fullPath;

/**
 *  根据默认 Scheme 来跳转
 *
 *  @param path   路径
 *  @param params 参数
 */
- (BOOL)routePath:(NSString *__nonnull)path params:(NSDictionary *__nullable)params;

/**
 *  根据默认 Scheme 来跳转
 *
 *  @param path   路径
 *  @param buildBlock 参数构建Block
 */
- (BOOL)routePath:(NSString *__nonnull)path
      buildParams:(void (^ __nonnull)(NSMutableDictionary<NSString *, NSString *> *__nonnull params))buildBlock;

/**
 *  注册一个路径到默认 Scheme
 *
 *  @param path   注册一个路径
 *  @param action 路径响应
 */
- (void)on:(NSString *__nonnull)path action:(YMRouterAction __nonnull)action;

/**
 *  注册一个别名到默认 Scheme
 *
 *  @param path    路径别名
 *  @param srcPath 路径
 */
- (void)alias:(NSString *__nonnull)path to:(NSString *__nonnull)srcPath;

@end
