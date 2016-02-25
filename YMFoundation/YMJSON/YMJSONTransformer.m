//
//  YMJSONTransformer.m
//  ProtoJSON
//
//  Created by 琰珂 郭 on 15/9/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMJSON.h"

#import "YMLogger.h"
#import "YMUtilsSuppressMacros.h"

#import <objc/runtime.h>

@implementation YMJSONTransformer

+ (instancetype __nonnull)shared {
  static dispatch_once_t onceToken;
  static YMJSONTransformer *_shared;
  dispatch_once(&onceToken, ^{
    _shared = [YMJSONTransformer new];
  });
  return _shared;
}

+ (SEL)selectorForDirectClassTransform:(Class __nonnull)cls {
  return sel_getUid([[NSString stringWithFormat:@"%@FromJSONObject:", NSStringFromClass(cls)] cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (SEL)selectorForDirectClassTransformWithGeneric:(Class __nonnull)cls {
  return sel_getUid([[NSString stringWithFormat:@"%@FromJSONObject:genericClass:", NSStringFromClass(cls)] cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (BOOL)canTransformJSONObjectToClass:(Class __nonnull)cls {
  if ([self instancesRespondToSelector:[self selectorForDirectClassTransform:cls]]) {
    return true;
  }
  return [cls conformsToProtocol:@protocol(YMDictionaryConvertible)];
}

+ (BOOL)canTransformJSONObjectToClass:(Class __nonnull)cls withGeneric:(Class __nonnull)genericCls {
  return [self instancesRespondToSelector:[self selectorForDirectClassTransformWithGeneric:cls]]
      && [self canTransformJSONObjectToClass:genericCls];
}

- (id __nullable)transformJSONObjectFrom:(id __nonnull)jsonObject toClass:(Class __nonnull)cls {
  SEL sel = [[self class] selectorForDirectClassTransform:cls];
  if ([self respondsToSelector:sel]) {
    SUPPRESS_START
    SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
    return [self performSelector:sel withObject:jsonObject];
    SUPPRESS_END
  } else {
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
      return [[cls alloc] initWithDictionary:jsonObject];
    }
    DLog(@"%@ is not dictionary, failed to transform to %@",
         NSStringFromClass([jsonObject class]),
         NSStringFromClass(cls));
  }
  return nil;
}

- (id __nullable)transformJSONObjectFrom:(id __nonnull)jsonObject toClass:(Class __nonnull)cls genericClass:(Class __nonnull)genericCls {
  SEL sel = [[self class] selectorForDirectClassTransformWithGeneric:cls];
  SUPPRESS_START
  SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
  return [self performSelector:sel withObject:jsonObject withObject:genericCls];
  SUPPRESS_END
}

- (NSString *)NSStringFromJSONObject:(id)object {
  if ([object isKindOfClass:[NSString class]]) {
    return object;
  }
  if ([object isKindOfClass:[NSNumber class]]) {
    return [((NSNumber *) object) stringValue];
  }
  return nil;
}

- (NSMutableString *)NSMutableStringFromJSONObject:(id)object {
  NSString *str = [self NSStringFromJSONObject:object];
  if (str == nil) {
    return nil;
  }
  return [NSMutableString stringWithString:str];
}

- (NSNumber *)NSNumberFromJSONObject:(id)object {
  if ([object isKindOfClass:[NSNumber class]]) {
    return object;
  }
  if ([object isKindOfClass:[NSString class]]) {
    return @([((NSString *) object) doubleValue]);
  }
  return nil;
}

- (NSDecimalNumber *__nullable)NSDecimalNumberFromJSONObject:(id __nonnull)object {
  if ([object isKindOfClass:[NSString class]]) {
    return [NSDecimalNumber decimalNumberWithString:object];
  }
  if ([object isKindOfClass:[NSNumber class]]) {
    return [NSDecimalNumber decimalNumberWithString:[((NSNumber *) object) stringValue]];
  }
  return nil;
}

- (NSDictionary *)NSDictionaryFromJSONObject:(id)object {
  if ([object isKindOfClass:[NSDictionary class]]) {
    return object;
  }
  return nil;
}

- (NSMutableDictionary *__nullable)NSMutableDictionaryFromJSONObject:(id __nonnull)object {
  if ([object isKindOfClass:[NSDictionary class]]) {
    return [[NSMutableDictionary alloc] initWithDictionary:object];
  }
  return nil;
}

- (NSDictionary *)NSDictionaryFromJSONObject:(id)object genericClass:(Class)genericClass {
  return [self NSMutableDictionaryFromJSONObject:object genericClass:genericClass];
}

- (NSMutableDictionary *)NSMutableDictionaryFromJSONObject:(id)object genericClass:(Class)genericClass {
  if ([object isKindOfClass:[NSDictionary class]]) {
    NSMutableDictionary *target = [NSMutableDictionary new];
    __block BOOL failed = false;
    [(NSDictionary *) object enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,
                                                                 id _Nonnull obj,
                                                                 BOOL *_Nonnull stop) {
      id tobj = [self transformJSONObjectFrom:obj toClass:genericClass];
      if (tobj == nil) {
        DLog(@"Cannot transform %@ to %@", NSStringFromClass([obj class]), NSStringFromClass(genericClass));
        *stop = failed = YES;
      } else {
        [target setObject:tobj forKey:key];
      }
    }];
    if (failed) {
      return nil;
    } else {
      return target;
    }
  }
  return nil;
}

- (NSArray *)NSArrayFromJSONObject:(id)object {
  if ([object isKindOfClass:[NSArray class]]) {
    return object;
  }
  return nil;
}

- (NSMutableArray *__nullable)NSMutableArrayFromJSONObject:(id __nonnull)object {
  if ([object isKindOfClass:[NSArray class]]) {
    return [[NSMutableArray alloc] initWithArray:object];
  }
  return nil;
}

- (NSArray *)NSArrayFromJSONObject:(id)object genericClass:(Class)genericClass {
  return [self NSMutableArrayFromJSONObject:object genericClass:genericClass];
}

- (NSMutableArray *)NSMutableArrayFromJSONObject:(id)object genericClass:(Class)genericClass {
  if ([object isKindOfClass:[NSArray class]]) {
    __block BOOL failed = false;
    NSMutableArray *target = [[NSMutableArray alloc] initWithCapacity:((NSArray *) object).count];
    [(NSArray *) object enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      id tobj = [self transformJSONObjectFrom:obj toClass:genericClass];
      if (tobj == nil) {
        DLog(@"Cannot transform %@ to %@", NSStringFromClass([obj class]), NSStringFromClass(genericClass));
        *stop = failed = YES;
      } else {
        [target addObject:tobj];
      }
    }];
    if (failed) {
      return nil;
    } else {
      return target;
    }
  }
  return nil;
}

- (NSSet *)NSSetFromJSONObject:(id)object {
  return [self NSMutableSetFromJSONObject:object];
}

- (NSMutableSet *)NSMutableSetFromJSONObject:(id)object {
  if ([object isKindOfClass:[NSArray class]]) {
    NSMutableSet *target = [[NSMutableSet alloc] initWithCapacity:[(NSArray *) object count]];
    [(NSArray *) object enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      [target addObject:obj];
    }];
    return target;
  }
  return nil;
}

- (NSSet *)NSSetFromJSONObject:(id)object genericClass:(Class)genericClass {
  return [self NSMutableSetFromJSONObject:object genericClass:genericClass];
}

- (NSMutableSet *)NSMutableSetFromJSONObject:(id)object genericClass:(Class)genericClass {
  if ([object isKindOfClass:[NSArray class]]) {
    NSMutableSet *target = [[NSMutableSet alloc] initWithCapacity:[(NSArray *) object count]];
    __block BOOL failed = NO;
    [(NSArray *) object enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      id tobj = [self transformJSONObjectFrom:obj toClass:genericClass];
      if (tobj == nil) {
        *stop = failed = YES;
      } else {
        [target addObject:tobj];
      }
    }];
    if (failed) {
      return nil;
    } else {
      return target;
    }
  }
  return nil;
}

@end

@implementation YMJSONTransformer (ReversTransforming)

+ (SEL)selectorForDirectIdenticallyClassTransformToJSONObject:(Class __nonnull)cls {
  return sel_getUid([[NSString stringWithFormat:@"JSONObjectFrom%@:", NSStringFromClass(cls)] cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (BOOL)canDirectIdenticallyTransformClassToJSONObject:(Class)cls {
  return [self instancesRespondToSelector:[self selectorForDirectIdenticallyClassTransformToJSONObject:cls]];
}

+ (BOOL)canDirectTransformClassToJSONObject:(Class)cls {
  BOOL found = false;
  while (cls != [NSObject class] && cls != NULL) {
    found = [self canDirectIdenticallyTransformClassToJSONObject:cls];
    if (found) {
      break;
    }
    cls = class_getSuperclass(cls);
  }
  return found;
}

+ (SEL)selectorForDirectClassTransformToJSONObject:(Class __nonnull)cls {
  SEL sel = NULL;
  while (cls != [NSObject class] && cls != NULL) {
    if ([self canDirectIdenticallyTransformClassToJSONObject:cls]) {
      sel = [self selectorForDirectIdenticallyClassTransformToJSONObject:cls];
      break;
    }
    cls = class_getSuperclass(cls);
  }
  return sel;
}

+ (BOOL)canTransformClassToJSONObject:(Class)cls {
  if ([self canDirectTransformClassToJSONObject:cls]) {
    return true;
  }
  return [cls conformsToProtocol:@protocol(YMDictionaryConvertible)];
}

- (id __nonnull)transformToJSONObject:(id)object {
  //  Use classForCoder to resolve cluster class
  SEL sel = [[self class] selectorForDirectClassTransformToJSONObject:[object classForCoder]];
  if (sel == NULL) {
    return [object toDictionary];
  } else {
    SUPPRESS_START
    SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
    return [self performSelector:sel withObject:object];
    SUPPRESS_END
  }
}

- (id)JSONObjectFromNSString:(NSString *)object {
  return object;
}

- (id)JSONObjectFromNSNumber:(NSNumber *)object {
  return object;
}

- (id __nonnull)JSONObjectFromNSDecimalNumber:(NSDecimalNumber *__nonnull)object {
  return [object stringValue];
}

- (id)JSONObjectFromNSDictionary:(NSDictionary *)object {
  NSMutableDictionary *target = [NSMutableDictionary new];
  [object enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
    [target setObject:[self transformToJSONObject:obj] forKey:key];
  }];
  return target;
}

- (id)JSONObjectFromNSArray:(NSArray *)object {
  NSMutableArray *target = [NSMutableArray new];
  [object enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    [target addObject:[self transformToJSONObject:obj]];
  }];
  return target;
}

- (id)JSONObjectFromNSSet:(NSSet *)object {
  return [self JSONObjectFromNSArray:[object allObjects]];
}

@end
