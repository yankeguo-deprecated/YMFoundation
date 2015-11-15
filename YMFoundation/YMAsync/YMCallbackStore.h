//
//  YMCallbackStore.h
//  YMXian
//
//  Created by Yanke Guo on 15/6/4.
//  Copyright (c) 2015年 Yanke Guo. All rights reserved.
//
//  回调容器是一个将多个回调统一管理的工具,非常适合用来将 Delegate 转换为 Block

#import <Foundation/Foundation.h>

@interface YMCallbackStore<ObjectType>: NSObject

/**
 *  初始化一个回调容器，并制定过期处理回调
 *
 *  @param expireHandler 回调过期处理回调，仅当 expires = 0 时可以传 nil
 *  @param expires       过期时间, 0 = 永不过期
 *
 *  @return 一个实例
 */
+ (id __nonnull)storeWithExpireHandler:(void (^ __nullable)(ObjectType __nonnull callback))expireHandler expires:(NSTimeInterval)expires;

/**
 *  添加一个回调，如果有设置过期，则开始过期倒计时
 *
 *  @param callback 回调
 *
 *  @return 返回回调在容器内的ID
 */
- (NSInteger)addCallback:(ObjectType __nonnull)callback;

/**
 *  执行所有回调，然后移除所有回调
 *
 *  WARNING: 内部使用了 dispatch_async(dispatch_get_main_queue(), ^{})
 *
 *  @param handler 处理回调的回调
 */
- (void)invokeAllCallbacks:(void (^ __nonnull)(ObjectType __nonnull callback))handler;

/**
 *  移除某个特定回调
 *
 *  @param callbackID 将回调加入容器时获取到的ID
 */
- (void)removeCallbackWithId:(NSInteger)callbackID;

@end
