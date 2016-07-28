//
//  YMModel.h
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//  YMModel is a YMJSON with id

#import <YMFoundation/YMJSON.h>
#import <YMFoundation/YMModelStore.h>
#import <YMFoundation/YMModelProvider.h>
#import <YMFoundation/YMIndexedModelArray.h>

@interface YMModel : YMJSON

@property(nonatomic, strong) NSString *__nonnull id;

@end
