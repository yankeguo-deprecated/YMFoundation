//
//  YMJSONDescriptor.m
//  ProtoJSON
//
//  Created by 琰珂 郭 on 15/9/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMJSON.h"

#import "YMUtilsSuppressMacros.h"
#import "YMLogger.h"

#import <objc/runtime.h>

@interface YMJSONDescriptor ()

@property(nonatomic, retain) Class cls;

@property(nonatomic, strong) NSMutableArray<YMJSONMappingItem *> *mapping;

@end

@implementation YMJSONDescriptor

+ (NSString *)classNameFromPropertyTypeDescription:(const char *)desc {
  NSParameterAssert(desc != NULL);
  NSString *propertyType = [NSString stringWithCString:desc encoding:NSUTF8StringEncoding];
  NSParameterAssert([propertyType hasPrefix:@"@\""] && [propertyType hasSuffix:@"\""]);
  return [propertyType substringWithRange:NSMakeRange(2, propertyType.length - 3)];
}

- (id)init {
  NSAssert(NO, @"Cannot call init directly");
  return nil;
}

- (id)initWithClass:(Class)cls {
  if (self = [super init]) {
    _cls = cls;
    _mapping = [NSMutableArray array];
  }
  return self;
}

+ (instancetype)descriptorForClass:(Class)cls {
  return [[self alloc] initWithClass:cls];
}

- (BOOL)applyDictionary:(NSDictionary *)dict toObject:(id)object {
  NSParameterAssert([object isKindOfClass:_cls]);

  for (YMJSONMappingItem *mapping in self.mapping) {
    id rawValue = [dict objectForKey:mapping.fieldName];
    id value = nil;

    if (rawValue == nil) {
      // Do nothing
    } else if (mapping.genericClass == NULL) {
      value = [[YMJSONTransformer shared] transformJSONObjectFrom:rawValue toClass:mapping.propertyClass];
    } else {
      value =
          [[YMJSONTransformer shared] transformJSONObjectFrom:rawValue toClass:mapping.propertyClass genericClass:mapping.genericClass];
    }

    //  Post-check nil
    if (value == nil) {
      if (mapping.option >= JSONFieldOptionRequired) {
        DLog(@"Transform failed: %@ -> %@", NSStringFromClass(rawValue), NSStringFromClass(mapping.propertyClass));
        return NO;
      } else if (mapping.option == JSONFieldOptionAutoFill) {
        value = [mapping.propertyClass new];
      }
    }

      //  Finally set
        SUPPRESS_START
        SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
    [object performSelector:mapping.propertySetterSelector withObject:value];
    SUPPRESS_END
  }

  return YES;
}

- (NSDictionary *__nonnull)toDictionaryWithObject:(id __nonnull)object keys:(NSArray<NSString *> *__nullable)keys {
  NSParameterAssert([object isKindOfClass:_cls]);
  NSMutableDictionary *dict = [NSMutableDictionary new];
  [self.mapping enumerateObjectsUsingBlock:^(YMJSONMappingItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    if (keys == nil || [keys containsObject:obj.propertyName]) {
      SUPPRESS_START
      SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
      id val = [object performSelector:obj.propertyGetterSelector];
      SUPPRESS_END
      if (val != nil) {
        [dict setObject:[[YMJSONTransformer shared] transformToJSONObject:val] forKey:obj.fieldName];
      }
    }
  }];
  return dict;
}

- (void)addAll:(NSArray<NSString *> *__nonnull)propertyNames {
  [propertyNames enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    [self add:obj];
  }];
}

- (void)add:(NSString *)propertyName {
  [self add:propertyName build:nil];
}

- (void)add:(NSString *)propertyName fieldName:(NSString *)fieldName {
  [self add:propertyName build:^(YMJSONMappingItem *_Nonnull mapping) {
    mapping.fieldName = fieldName;
  }];
}

- (void)addAllRequired:(NSArray<NSString *> *__nonnull)propertyNames {
  [propertyNames enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    [self addRequired:obj];
  }];
}

- (void)addRequired:(NSString *__nonnull)propertyName {
  [self add:propertyName build:^(YMJSONMappingItem *_Nonnull mapping) {
    mapping.option = JSONFieldOptionRequired;
  }];
}

- (void)addAutoFill:(NSString *__nonnull)propertyName {
  [self add:propertyName build:^(YMJSONMappingItem *_Nonnull mapping) {
    mapping.option = JSONFieldOptionAutoFill;
  }];
}

- (void)addRequired:(NSString *__nonnull)propertyName genericClass:(Class __nonnull)genericClass {
  [self add:propertyName build:^(YMJSONMappingItem *_Nonnull mapping) {
    mapping.option = JSONFieldOptionRequired;
    mapping.genericClass = genericClass;
  }];
}

- (void)add:(NSString *__nonnull)propertyName genericClass:(Class __nonnull)genericClass {
  [self add:propertyName build:^(YMJSONMappingItem *_Nonnull mapping) {
    mapping.genericClass = genericClass;
  }];
}

- (void)add:(NSString *)propertyName build:(void (^)(YMJSONMappingItem *_Nonnull))build {
  YMJSONMappingItem *mapping = [YMJSONMappingItem mappingWithPropertyName:propertyName];
  if (build) { build(mapping); }
  //  Check propertyName
  NSParameterAssert(mapping.propertyName != nil);
  //  Check fieldName
  NSParameterAssert(mapping.fieldName != nil);
  //  Check property definition
  objc_property_t prop = class_getProperty(_cls, [mapping.propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
  if (prop == NULL) {
    NSAssert(NO, @"Property named %@ not found", propertyName);
  }
  //  Check property class
  char *rawPropertyType = property_copyAttributeValue(prop, "T");
  NSString *className = [YMJSONDescriptor classNameFromPropertyTypeDescription:rawPropertyType];
  mapping.propertyClass = NSClassFromString(className);
#ifdef ENABLE_DEBUG_SYSTEM
  NSParameterAssert(mapping.propertyClass != NULL);
  //  Check transform
  if (mapping.genericClass == NULL) {
    NSParameterAssert([YMJSONTransformer canTransformJSONObjectToClass:mapping.propertyClass]);
    //  Check reverse transform
    NSParameterAssert([YMJSONTransformer canTransformClassToJSONObject:mapping.propertyClass]);
  } else {
    NSParameterAssert([YMJSONTransformer canTransformJSONObjectToClass:mapping.propertyClass withGeneric:mapping.genericClass]);
    //  Check reverse transform
    NSParameterAssert([YMJSONTransformer canTransformClassToJSONObject:mapping.propertyClass]);
    NSParameterAssert([YMJSONTransformer canTransformClassToJSONObject:mapping.genericClass]);
  }
#endif

  [_mapping addObject:mapping];
}

@end
