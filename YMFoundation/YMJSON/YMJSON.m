//
//  YMJSON.m
//  ProtoJSON
//
//  Created by 琰珂 郭 on 15/9/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMJSON.h"

#import <objc/runtime.h>

static const void *YMJSONDescriptorKey = &YMJSONDescriptorKey;

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
    objc_setAssociatedObject(self, YMJSONDescriptorKey, desc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}

+ (YMJSONDescriptor *)descriptor {
  return objc_getAssociatedObject(self, YMJSONDescriptorKey);
}

+ (void)buildDescriptor:(YMJSONDescriptor *)descriptor { }

- (id)init {
  if (self = [super init]) {
    [self didInit];
  }
  return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    if (![[[self class] descriptor] applyDictionary:dict toObject:self]) {
      return nil;
    }
    if (![self validate]) {
      return nil;
    }
    [self didInit];
  }
  return self;
}

- (id __nullable)initWithString:(NSString *__nonnull)string {
  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  if (![dict isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  return [self initWithDictionary:dict];
}

- (void)didInit {}

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

#pragma mark - NSCopy

- (id)copyWithZone:(NSZone *)zone {
  return [[[self class] alloc] initWithDictionary:self.toDictionary];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
  return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  NSDictionary* dictionary = [aDecoder decodeObjectForKey:@"dictionary"];
  if ([dictionary isKindOfClass:[NSDictionary class]]) {
    id instance = [[[self class] alloc] initWithDictionary:dictionary];
    if (instance != nil) { return instance; }
  }
  // Fallback to initialize a new empty instance
  return [[[self class] alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:[self toDictionary] forKey:@"dictionary"];
}

@end