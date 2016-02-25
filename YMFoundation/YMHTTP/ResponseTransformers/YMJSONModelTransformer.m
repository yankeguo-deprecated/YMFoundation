//
//  YMJSONModelTransformer.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMJSONModelTransformer.h"

#import "YMJSON.h"

@implementation YMJSONModelTransformer

+ (instancetype __nonnull)transformerWithModelClass:(Class __nonnull)clazz isArray:(BOOL)isArray {
  return [[self alloc] initWithModelClass:clazz isArray:isArray];
}

- (id __nonnull)initWithModelClass:(Class __nonnull)clazz isArray:(BOOL)isArray {
  if (self = [super init]) {
    NSParameterAssert([clazz conformsToProtocol:@protocol(YMDictionaryConvertible)]);
    _modelClass = clazz;
    _modelArray = isArray;
  }
  return self;
}

- (id __nullable)transformResponse:(id __nullable)response error:(NSError *__nullable *__nonnull)error request:(YMHTTPRequest *__nonnull)request {
  if (_modelArray) {
    if ([response isKindOfClass:[NSArray class]]) {
      return [_modelClass arrayFromDictionaries:response];
    } else {
      return nil;
    }
  } else {
    if ([response isKindOfClass:[NSDictionary class]]) {
      return [(id<YMDictionaryConvertible>) [_modelClass alloc] initWithDictionary:response];
    } else {
      return nil;
    }
  }
}

- (NSString *)description {
  NSString *desc = NSStringFromClass([self class]);
  if (self.modelArray) {
    return [desc stringByAppendingFormat:@"(modelArrayClass = %@)", NSStringFromClass(_modelClass)];
  } else {
    return [desc stringByAppendingFormat:@"(modelModelClass = %@)", NSStringFromClass(_modelClass)];
  }
}

@end
