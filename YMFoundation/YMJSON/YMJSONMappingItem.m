//
//  YMJSONMappingItem.m
//  ProtoJSON
//
//  Created by 琰珂 郭 on 15/9/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMJSON.h"

@implementation YMJSONMappingItem

- (id)init {
  NSAssert(NO, @"BAD INIT");
  return nil;
}

+ (instancetype __nonnull)mappingWithPropertyName:(NSString *__nonnull)propertyName {
  return [[self alloc] initWithPropertyName:propertyName];
}

- (id __nonnull)initWithPropertyName:(NSString *__nonnull)propertyName {
  if (self = [super init]) {
    _propertyName = [propertyName copy];
    _fieldName = [_propertyName copy];
    _propertySetterSelector = sel_getUid([[self buildSetterSelectorName] cStringUsingEncoding:NSUTF8StringEncoding]);
    _propertyGetterSelector = sel_getUid([_propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
  }
  return self;
}

- (NSString *)propertyClassName {
  return NSStringFromClass(self.propertyClass);
}

- (void)setPropertyClassName:(NSString *)propertyClassName {
  self.propertyClass = NSClassFromString(propertyClassName);
  NSParameterAssert(self.propertyClass);
}

- (NSString *)genericClassName {
  return NSStringFromClass(self.genericClass);
}

- (void)setArrayClassName:(NSString *)genericClassName {
  self.genericClass = NSClassFromString(genericClassName);
  NSParameterAssert(self.genericClass);
}

- (NSString *__nonnull)buildSetterSelectorName {
  NSString *first = [[_propertyName substringToIndex:1] uppercaseString];
  NSString *remainning = [_propertyName substringFromIndex:1];
  return [NSString stringWithFormat:@"set%@%@:", first, remainning];
}

@end
