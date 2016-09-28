//
//  YMResourceStatus.h
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import <Foundation/Foundation.h>
#import "YRStatus.h"

@interface YRStatusPair: NSObject<NSSecureCoding, NSCopying>

@property(nonatomic, strong, readonly) YRStatus *__nonnull status;

@property(nonatomic, strong, readonly) YRStatus *__nonnull lastStatus;

+ (instancetype __nonnull)statusPair;

- (instancetype __nonnull)initWithStatus:(YRStatus *__nonnull)status lastStatus:(YRStatus *__nonnull)lastStatus;

- (instancetype __nonnull)statusPairWithNewStatus:(YRStatus *__nonnull)newStatus;

@end