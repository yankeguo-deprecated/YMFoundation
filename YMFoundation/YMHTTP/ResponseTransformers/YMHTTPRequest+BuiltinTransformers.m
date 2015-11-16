//
//  YMHTTPRequest+BuiltinTransformers.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMHTTPRequest+BuiltinTransformers.h"

#import "YMJSONResponseTransformer.h"
#import "YMKeyPathTransformer.h"
#import "YMJSONModelTransformer.h"
#import "YMClassCheckTransformer.h"

@implementation YMHTTPRequest (BuiltinTransformers)

- (void)useJSONResponse {
  [self addResponseTransformer:[YMJSONResponseTransformer new]];
}

- (void)addKeyPathTransform:(NSString *)keyPath {
  [self addResponseTransformer:[YMKeyPathTransformer transformerWithKeyPath:keyPath]];
}

- (void)addClassCheckTransform:(Class)model {
  [self addResponseTransformer:[YMClassCheckTransformer validatorWithClass:model]];
}

- (void)addModelObjectTransform:(Class)model {
  [self addResponseTransformer:[YMJSONModelTransformer transformerWithModelClass:model isArray:NO]];
}

- (void)addModelArrayTransform:(Class)model {
  [self addResponseTransformer:[YMJSONModelTransformer transformerWithModelClass:model isArray:YES]];
}

- (void)removeModelTransform {
  [self removeResponseTransformerByClass:[YMJSONModelTransformer class]];
}

@end
