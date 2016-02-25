//
//  YMJSON.m
//  ProtoJSON
//
//  Created by 琰珂 郭 on 15/9/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMJSON.h"

#import <objc/runtime.h>

const void *JSONDescriptorKey = &JSONDescriptorKey;

@implementation YMJSON

+ (void)initialize {
  [super initialize];

  if (self != [YMJSON class]) {
    //  在子类中运行

    //  创建描述
    YMJSONDescriptor *desc = [YMJSONDescriptor descriptorForClass:self];
    //  由子类构造描述
    [self buildDescriptor:desc];
    //  保存描述
    objc_setAssociatedObject(self, JSONDescriptorKey, desc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}

+ (YMJSONDescriptor *)descriptor {
  return objc_getAssociatedObject(self, JSONDescriptorKey);
}

+ (void)buildDescriptor:(YMJSONDescriptor *)descriptor { }

- (id)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    if (![[[self class] descriptor] applyDictionary:dict toObject:self]) {
      return nil;
    }
    if (![self validate]) {
      return nil;
    }
  }
  return self;
}

- (id __nullable)initWithString:(NSString *__nonnull)string {
  NSDictionary *dict =
      [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  if (![dict isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  return [self initWithDictionary:dict];
}

+ (NSArray *)arrayFromDictionaries:(NSArray<NSDictionary *> *)dictionaries {
  return [[YMJSONTransformer shared] transformJSONObjectFrom:dictionaries toClass:[NSArray class] genericClass:self.class];
}

- (NSDictionary *__nonnull)toDictionaryWithKeys:(NSArray<NSString *> *__nullable)keys {
  return [[[self class] descriptor] toDictionaryWithObject:self keys:keys];
}

- (NSDictionary *)toDictionary {
  return [self toDictionaryWithKeys:nil];
}

- (NSString *__nonnull)toJSONString {
  NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:kNilOptions error:nil];
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)toString {
  return [self toJSONString];
}

- (BOOL)validate {
  return YES;
}

- (id)copyWithZone:(NSZone *)zone {
  return [[[self class] alloc] initWithDictionary:self.toDictionary];
}

@end