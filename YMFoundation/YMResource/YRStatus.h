//
// Created by Yanke Guo on 16/8/4.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YRStatusType) {
  YRStatusTypeInited,
  YRStatusTypeLoading,
  YRStatusTypeComplete,
};

@class YRStatus;

typedef YRStatus *__nonnull (^YRStatusBoolConfigBlock)(BOOL value);

@interface YRStatus : NSObject<NSCopying, NSSecureCoding>

+ (instancetype __nonnull)status;

+ (instancetype __nonnull)statusWithType:(YRStatusType)type;

- (id __nonnull)initWithType:(YRStatusType)type;

+ (instancetype __nonnull)inited;

+ (instancetype __nonnull)loading;

+ (instancetype __nonnull)complete;

@property(nonatomic, assign) YRStatusType type;

@property(nonatomic, readonly, getter=isInited) BOOL inited;
@property(nonatomic, readonly, getter=isLoading) BOOL loading;
@property(nonatomic, readonly, getter=isComplete) BOOL complete;

@property(nonatomic, readonly) BOOL notInited;
@property(nonatomic, readonly) BOOL notLoading;
@property(nonatomic, readonly) BOOL notComplete;

@property(nonatomic, readonly) YRStatus *__nonnull setInited;
@property(nonatomic, readonly) YRStatus *__nonnull setLoading;
@property(nonatomic, readonly) YRStatus *__nonnull setComplete;

//  Option

@property(nonatomic, assign) BOOL isPartial;
@property(nonatomic, assign) BOOL isUpdated;
@property(nonatomic, assign) BOOL isFailed;
@property(nonatomic, assign) BOOL isEmpty;
@property(nonatomic, assign) BOOL isHasMore;
@property(nonatomic, assign) BOOL isCached;

@property(nonatomic, readonly, strong) YRStatusBoolConfigBlock __nonnull setPartial;
@property(nonatomic, readonly, strong) YRStatusBoolConfigBlock __nonnull setUpdated;
@property(nonatomic, readonly, strong) YRStatusBoolConfigBlock __nonnull setFailed;
@property(nonatomic, readonly, strong) YRStatusBoolConfigBlock __nonnull setEmpty;
@property(nonatomic, readonly, strong) YRStatusBoolConfigBlock __nonnull setHasMore;
@property(nonatomic, readonly, strong) YRStatusBoolConfigBlock __nonnull setCached;

@property(nonatomic, readonly) YRStatus *__nonnull partial;
@property(nonatomic, readonly) YRStatus *__nonnull updated;
@property(nonatomic, readonly) YRStatus *__nonnull failed;
@property(nonatomic, readonly) YRStatus *__nonnull empty;
@property(nonatomic, readonly) YRStatus *__nonnull hasMore;
@property(nonatomic, readonly) YRStatus *__nonnull cached;

@property(nonatomic, readonly) YRStatus *__nonnull notPartial;
@property(nonatomic, readonly) YRStatus *__nonnull notUpdated;
@property(nonatomic, readonly) YRStatus *__nonnull notFailed;
@property(nonatomic, readonly) YRStatus *__nonnull notEmpty;
@property(nonatomic, readonly) YRStatus *__nonnull noMore;
@property(nonatomic, readonly) YRStatus *__nonnull notCached;

@end
