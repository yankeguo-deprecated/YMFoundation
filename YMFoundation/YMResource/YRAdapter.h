//
// Created by Yanke Guo on 16/9/8.
//

#import <YMFoundation/YMAsync.h>
#import "YRStatusPair.h"

@interface YRAdapter : NSObject

@property(nonatomic, readonly) YMAsyncQueue *__nonnull queue;

@property(nonatomic, strong) YRStatusPair *__nonnull statusPair;

@property(nonatomic, assign) YRStatus *__nonnull status;

- (void)appendStatus:(YRStatus *__nonnull)status;

@end