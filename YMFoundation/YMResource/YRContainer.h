//
// Created by Yanke Guo on 16/8/16.
//

#import <Foundation/Foundation.h>
#import "YMAsyncQueue.h"
#import "YRStatusPair.h"

/**
 * YRContainer 系列提供了一个 Wrapper,可以用来包裹任何对象,来为其添加数据状态信息
 */
@interface YRContainer : NSObject

@property(nonatomic, readonly) YMAsyncQueue *__nonnull queue;

@property(nonatomic, strong) YRStatusPair *__nonnull statusPair;

@property(nonatomic, strong) YRStatus *__nonnull status;

- (void)appendStatus:(YRStatus *__nonnull)status;

@property(nonatomic, strong) id __nullable value;

+ (instancetype __nonnull)container;

@end

@interface YRObjectContainer<ObjectType> : YRContainer

@property(nonatomic, strong) ObjectType __nullable value;

@end

@interface YRArrayContainer<ObjectType> : YRContainer

@property(nonatomic, strong) NSArray<ObjectType> *__nullable value;

- (NSArray<ObjectType>*__nonnull)valueDefinite;

- (void)appendArray:(NSArray<ObjectType> *__nullable)array;

@end