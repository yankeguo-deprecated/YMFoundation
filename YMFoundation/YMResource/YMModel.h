//
//  YMModel.h
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//  YMModel is a YMJSON with id

#import <YMFoundation/YMJSON.h>
#import <YMFoundation/YMAsync.h>

#import "YRStatusPair.h"
#import "YRAdapter.h"

extern NSString *__nonnull YMModelNilId;

@interface YMModel : YMJSON

@property(nonatomic, strong) NSString *__nonnull id;

@property(nonatomic, readonly, getter=isNilId) BOOL nilId;

///////////////////////  Resource   ////////////////////////

/**
 * Adapter encapsule statusPair and queue, you can assign another adapter to share queue and statusPair among multiple YMModel or YMModelArray
 */
@property(nonatomic, strong) YRAdapter *__nonnull adapter;

@property(nonatomic, readonly) YMAsyncQueue *__nonnull queue;

@property(nonatomic, strong) YRStatusPair *__nonnull statusPair;

@property(nonatomic, assign) YRStatus *__nonnull status;

- (void)appendStatus:(YRStatus *__nonnull)status;

////////////////////////////////////////////////////////////

@end
